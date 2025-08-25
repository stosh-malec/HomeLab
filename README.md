# HomeLab
This repository contains my Homelab setup and workstation configurations. High Availability is achieved using K3s running on each node in the cluster, while Terraform manages infrastructure at the lowest level to simplify node replacement and addition. 

## Terraform with Terragrunt
This repository uses Terragrunt to manage Terraform state and simplify deployment workflows.

### Getting Started
1. Install prerequisites:
   ```bash
   brew install terraform terragrunt sops
   ```

2. Set up environment variables:
   ```bash
   export TF_VAR_project_id="your-gcp-project-id"
   export TF_VAR_bucket_name="your-gcp-bucket-name"
   export TF_VAR_service_account_email="your-service-account@your-project.iam.gserviceaccount.com"
   ```

3. Initialize and apply GCP resources first:
   ```bash
   cd terraform/roots/gcp
   ./tg init
   ./tg apply
   ```

4. Deploy Kubernetes resources (including Longhorn as the first dependency):
   ```bash
   ./tg init
   ./tg apply
   ```

### SOPS Encryption
This repository uses SOPS with GCP KMS for encrypting sensitive files. The `.sops.yaml` file contains the configuration.

To encrypt/decrypt files:
```bash
# Encrypt a file
./scripts/sops-encrypt.sh encrypt path/to/file.dec.yaml

# Decrypt a file
./scripts/sops-encrypt.sh decrypt path/to/file.enc.yaml
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
    * `ssh-keygen -t rsa -b 4096 && cat ~/.ssh/id_rsa.pub`
* On-Mac-Mini 
    * `echo "PASTE_THE_PUBLIC_KEY_HERE" > ~/.ssh/my-macbook-key.pub`
    * `multipass launch --name k3s-master-X --cpus 1 --memory 1G --disk 20G  --network en0 --cloud-init <(echo "users: [{name: ubuntu, ssh_authorized_keys: [\"$(cat ~/.ssh/my-macbook-key.pub)\"]}]")`
    * `multipass launch --name k3s-worker-X --cpus 7 --memory 13G --disk 150G --network en0 --cloud-init <(echo "users: [{name: ubuntu, ssh_authorized_keys: [\"$(cat ~/.ssh/my-macbook-key.pub)\"]}]")` 
* Unifi: Fix IPs of the Multipass VMs & Mac Mini

Use K3sup to Configure Cluster on Macbook
* Take Down Multipass Adapter over SSH to prevent K3s from binding to it over the bridged adapter
    * `sudo ip link set enp0s1 down / up`
* Grab Token from Master Node 1
    * `sudo cat /var/lib/rancher/k3s/server/node-token`
* To Join Control Plane to Cluster: 
    * `curl -sfL https://get.k3s.io | K3S_URL=https://<Master Node 1>:6443 K3S_TOKEN=<node-token> sh -s - server --node-ip <New Master IP> --advertise-address <New Master IP>`
* To Join Workers to the Cluster
    * `curl -sfL https://get.k3s.io | K3S_URL=https://<A Master Node>:6443 K3S_TOKEN=<node-token> sh -s - agent --node-ip 192.168.1.X`