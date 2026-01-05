# HomeLab
This repository contains my Homelab setup and workstation configurations. High Availability is achieved using K3s running on each node in the cluster, while Terraform manages infrastructure at the lowest level to simplify node replacement and addition. 

## Terraform

### Prerequisites
```bash
# Install terraform
brew install terraform

# Load environment variables (contains Twingate API token, etc.)
source .env
```

### Apply Infrastructure
```bash
# GCP resources (must be applied first - homelab depends on its outputs)
cd terraform/roots/gcp
terraform init
terraform apply

# Homelab Kubernetes resources
cd terraform/roots/homelab
terraform init
terraform apply
```

### Encryption
We use GCP KMS for encrypting and decrypting secrets. 

* To encrypt/decrypt files:
    ```bash
    # Encrypt a file
    ./scripts/sops.sh encrypt <output-file> <encrypted-file>

    # Decrypt a file
    ./scripts/sops.sh decrypt <encrypted-file> <output-file>
    ```

## Terraform Structure
### Roots
* Google Cloud Platform: `terraform/roots/gcp` 
* On-Prem: `terraform/roots/homelab`

### Modules
#### Infrastucture Tooling
* Google Cloud Storage: `terraform/modules/gcp-storage`
    * Used for remote Persistant Volume Backups & TFState
* Google Cloud KMS: `terraform/modules/gcp-kms`
    * Used for SOPS encryption of sensitive files
* Twingate: `terraform/modules/twingate`
    * Helm Deployment of Redundant Twingate Connectors
* Velero: `terraform/modules/velero`
    * Helm Deployment of Velero
#### Hosted Game Servers
* Mincraft Server: `terraform/modules/minecraft`
    * Helm Deployment of the Minecraft Server

## Hardware
* 2x m4 Mac Mini's
* Unifi Dream Machine, Unfi Comcast Modem, Unifi PoE Switches, U7 APs

### New Hardware Setup
Do not enable File-Vault. Login with AppleID, Enable User Auto-Login, Enable Remote Management, Disable Sleep, and Enable Automatic Startup.

Setup Two VMs for K3s
* On-Macbook 
    ```bash
    `ssh-keygen -t rsa -b 4096 && cat ~/.ssh/id_rsa.pub`
    ```
* On-Mac-Mini 
    ```bash
    echo "PASTE_THE_PUBLIC_KEY_HERE" > ~/.ssh/my-macbook-key.pub

    multipass launch --name k3s-master-X --cpus 1 --memory 1G --disk 20G  --network en0 --cloud-init <(echo "users: [{name: ubuntu, ssh_authorized_keys: [\"$(cat ~/.ssh/my-macbook-key.pub)\"]}]")
    
    multipass launch --name k3s-worker-X --cpus 7 --memory 13G --disk 150G --network en0 --cloud-init <(echo "users: [{name: ubuntu, ssh_authorized_keys: [\"$(cat ~/.ssh/my-macbook-key.pub)\"]}]")
    ```
* Unifi: Fix IPs of the Multipass VMs & Mac Mini

* Take Down Multipass Adapter over SSH to prevent K3s from binding to it over the bridged adapter
    ```bash
    sudo ip link set enp0s1 down / up
    ```
* Grab token from master node
    ```bash
    sudo cat /var/lib/rancher/k3s/server/node-token
    ```

* Join additional control plane nodes
    ```bash
    curl -sfL https://get.k3s.io | K3S_URL=https://<Master Node 1>:6443 K3S_TOKEN=<node-token> sh -s - server \
      --node-ip=192.168.1.X \
      --flannel-iface=enp0s2 \
      --flannel-backend=vxlan \
      --cluster-cidr=10.42.0.0/16 \
      --service-cidr=10.43.0.0/16 \
      --node-external-ip=192.168.1.X
    ```

* Join worker nodes
    ```bash
    curl -sfL https://get.k3s.io | K3S_URL=https://<Master Node>:6443 K3S_TOKEN=<node-token> sh -s - agent \
      --node-ip=192.168.1.X \
      --flannel-iface=enp0s2 \
      --node-external-ip=192.168.1.X
    ```
    
* Apply taints to new Worker and Control Plane Nodes
    ```bash
    for NODE in new_master_1 new_master_etc; do
        kubectl label node $NODE node-role.kubernetes.io/control-plane=true node-type=control-plane --overwrite
        kubectl taint node $NODE node-role.kubernetes.io/control-plane=true:NoSchedule --overwrite || true
    done

    for NODE in new_worker_1 new_worker_etc; do
        kubectl label node $NODE node-role.kubernetes.io/worker=true node-type=worker --overwrite
    done
    ```

## Backup & Restore

### Minecraft World Backups
The mcbackup sidecar automatically backs up Minecraft world data to GCS every 24 hours.

- **Storage:** `gs://stosh-homelab-velero-backup/minecraft-world-backups/`
- **Format:** Compressed `.tgz` files
- **Retention:** 7 days (auto-pruned)

### List Backups
```bash
gsutil ls gs://stosh-homelab-velero-backup/minecraft-world-backups/
```

### Restore Minecraft World
```bash
# 1. Scale down minecraft
kubectl scale deployment minecraft-server -n games --replicas=0

# 2. Download the backup you want
gsutil cp gs://stosh-homelab-velero-backup/minecraft-world-backups/world-YYYYMMDD-HHMMSS.tgz .

# 3. Create a debug pod to access the PVC
kubectl run mc-restore -n games --image=busybox --restart=Never --overrides='
{
  "spec": {
    "containers": [{
      "name": "mc-restore",
      "image": "busybox",
      "command": ["sleep", "3600"],
      "volumeMounts": [{
        "name": "datadir",
        "mountPath": "/data"
      }]
    }],
    "volumes": [{
      "name": "datadir",
      "persistentVolumeClaim": {
        "claimName": "minecraft-server-datadir"
      }
    }]
  }
}'

# 4. Copy and extract backup
kubectl cp world-YYYYMMDD-HHMMSS.tgz games/mc-restore:/tmp/
kubectl exec -n games mc-restore -- tar -xzf /tmp/world-YYYYMMDD-HHMMSS.tgz -C /data

# 5. Cleanup and scale back up
kubectl delete pod mc-restore -n games
kubectl scale deployment minecraft-server -n games --replicas=1

# 6. Verify pod is running
kubectl get pods -n games
```

### Velero (Ad-hoc Use)
Velero is installed but has no scheduled backups. Use for ad-hoc full namespace backups if needed:
```bash
velero backup create games-manual-$(date +%Y%m%d) --include-namespaces games
```