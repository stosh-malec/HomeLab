# HomeLab
This repository contains my Homelab setup and workstation configurations. High Availability is achieved using K3s running on each node in the cluster, while Terraform manages infrastructure at the lowest level to simplify node replacement and addition. 

## Terraform Apply's
To ensure compatibility, docker containers are used to isolate terraform and terragrunt versions.

* To apply use
   ```bash
   cd terraform/roots/gcp
   ./tg init
   ./tg apply
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
    * Used for remote Persistant Volume Backups
* Google Cloud KMS: `terraform/modules/gcp-kms`
    * Used for SOPS encryption of sensitive files
* Twingate: `terraform/modules/twingate`
    * Helm Deployment of Redundant Twingate Connectors
* Longhorn: `terraform/modules/longhorn`
    * Helm Deployment of Longhorn
#### Hosted Game Servers
* Mincraft Modded Server: `terraform/modules/minecraft`
    * Helm Deployment of the Modded Minecraft Server
* Satisfactory Experimental: `terraform/modules/satisfactory`
    * Helm Deployment of the Satisfactory Experimental Server

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