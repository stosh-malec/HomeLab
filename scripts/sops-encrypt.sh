#!/bin/bash

# Script to encrypt/decrypt files using SOPS with GCP KMS
# Usage:
#   ./sops-encrypt.sh encrypt path/to/file.dec.yaml
#   ./sops-encrypt.sh decrypt path/to/file.enc.yaml

set -e

ACTION=$1
FILE=$2

if [ "$ACTION" != "encrypt" ] && [ "$ACTION" != "decrypt" ]; then
    echo "Invalid action. Use 'encrypt' or 'decrypt'."
    exit 1
fi

if [ ! -f "$FILE" ]; then
    echo "File not found: $FILE"
    exit 1
fi

# Export GCP KMS resource from Terraform output
export SOPS_KMS_RESOURCE=$(cd terraform/roots/gcp && terragrunt output -raw kms_key_id)

if [ -z "$SOPS_KMS_RESOURCE" ]; then
    echo "ERROR: Could not get KMS resource from Terraform output."
    echo "Make sure you have applied the GCP Terraform configuration first."
    exit 1
fi

if [ "$ACTION" == "encrypt" ]; then
    # Validate that it's a .dec.* file
    if [[ ! $FILE =~ \.dec\. ]]; then
        echo "Error: File to encrypt should have .dec. in the name (e.g., values.dev.dec.yaml)"
        exit 1
    fi
    
    # Calculate output file name (replace .dec. with .enc.)
    OUTPUT=${FILE/.dec./.enc.}
    
    echo "Encrypting $FILE to $OUTPUT..."
    sops --encrypt "$FILE" > "$OUTPUT"
    echo "Encryption complete. Encrypted file saved to $OUTPUT"
elif [ "$ACTION" == "decrypt" ]; then
    # Validate that it's a .enc.* file
    if [[ ! $FILE =~ \.enc\. ]]; then
        echo "Error: File to decrypt should have .enc. in the name (e.g., values.dev.enc.yaml)"
        exit 1
    fi
    
    # Calculate output file name (replace .enc. with .dec.)
    OUTPUT=${FILE/.enc./.dec.}
    
    echo "Decrypting $FILE to $OUTPUT..."
    sops --decrypt "$FILE" > "$OUTPUT"
    echo "Decryption complete. Decrypted file saved to $OUTPUT"
fi
