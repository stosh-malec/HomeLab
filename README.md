# HomeLab

This repository contains Homelab deployments and personal workstation setups

## Applications

Here's a list of the applications currently running in my homelab:

* **Minecraft Server:**
    * Vanilla+ 
* **Satisfactory Server:**
    * Experimental statefull set with persistance
* **Longhorn:**
    * A HA distributed storage system for Kubernetes.
    * Automatic Cloud Backups to GCP
* **Twingate:**
    * Enables secure, limited access to internal applications/game servers for myself and friends

## Hardware

* Kubernetes cluster running on 3 single board computers.
    * Each node is equipped with an Intel i9 processor, 16GB DDR4 RAM, and a 1TB NVMe SSDs.
* Unifi Dream Machine, Unfi Comcast Modem, Unifi PoE Switches, U7 APs


# Terraform

The terraform directory contains configurations for cloud infrastructure and Kubernetes deployments utilized by the Homelab.

## Terraform Modules

### Homelab Kubernetes Deployments

The `terraform/roots/homelab` directory contains Terraform configurations for deploying applications to the Kubernetes cluster:

* **Minecraft Server:** Deploys a Minecraft server with modpacks and persistent storage
* **Satisfactory Server:** Deploys a dedicated Satisfactory game server

To deploy applications to the Kubernetes cluster:

```bash
cd ./terraform/roots/homelab/

# Initialize Terraform
terraform init

# Plan the changes
terraform plan

# Apply the changes
terraform apply
```

### GCP Cloud Storage for Backups

The `terraform/roots/gcp` directory contains configurations for cloud infrastructure like backup storage.

## Setup

1. Ensure Docker is installed on your system
2. Run the setup script:
   ```bash
   ./terraform/roots/gcp/setup.sh
   ```

## GCP Authentication

1. Install the gcloud CLI if not already installed
2. Authenticate with your Google account:
   ```bash
   gcloud auth login
   ```
3. Set your project:
   ```bash
   gcloud config set project your-project-id
   ```

## Usage

Navigate to the gcp-backup directory and use the wrapper script to run Terraform commands:

```bash
cd ./terraform/roots/gcp/

# Copy and edit the variables file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your GCP project information

# Initialize Terraform
./tf init

# Plan the changes
./tf plan

# Apply the changes
./tf apply
```