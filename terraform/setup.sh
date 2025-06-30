#!/bin/bash
# Setup script for Terraform environments

# Check for Docker
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Please install Docker first."
    exit 1
fi

# Make all tf scripts executable
find ./roots -name "tf" -exec chmod +x {} \;

# List available roots
echo "Available environments:"
find ./roots -mindepth 1 -maxdepth 1 -type d | sed 's|./roots/||'

# Ask which root to initialize
read -p "Which environment would you like to initialize? " ENV

if [ -d "./roots/$ENV" ]; then
    # Change to the selected root and run tf init
    echo "Initializing $ENV environment..."
    cd ./roots/$ENV && ./tf init
    
    # Check if tfvars file exists
    if [ -f terraform.tfvars ]; then
        echo "terraform.tfvars already exists. Skipping creation."
    else
        if [ -f terraform.tfvars.example ]; then
            echo "Creating terraform.tfvars from example..."
            cp terraform.tfvars.example terraform.tfvars
            echo "Please edit terraform.tfvars with your specific details."
        fi
    fi
else
    echo "Error: Environment $ENV not found."
    exit 1
fi 