#!/bin/bash
# Simple script to encrypt/decrypt files using GCP KMS directly
# Usage: 
#   ./simple-encrypt.sh encrypt <file>
#   ./simple-encrypt.sh decrypt <encrypted-file> <output-file>

set -e

# Check arguments
ACTION=$1
FILE=$2
OUTPUT_FILE=$3

if [ -z "$ACTION" ] || [ -z "$FILE" ]; then
  echo "Usage: $0 encrypt <file>"
  echo "       $0 decrypt <encrypted-file> <output-file>"
  exit 1
fi

if [ "$ACTION" = "encrypt" ]; then
  # Check if file exists
  if [ ! -f "$FILE" ]; then
    echo "File not found: $FILE"
    exit 1
  fi
  
  # Set output filename if not specified
  OUTPUT="${FILE}.enc"
  
  # Encrypt file
  echo "Encrypting $FILE to $OUTPUT..."
  gcloud kms encrypt \
    --location=us-central1 \
    --keyring=sops-keyring \
    --key=sops-key \
    --plaintext-file="$FILE" \
    --ciphertext-file="$OUTPUT"
  
  echo "Encryption complete. File encrypted to $OUTPUT"

elif [ "$ACTION" = "decrypt" ]; then
  # Check if file exists
  if [ ! -f "$FILE" ]; then
    echo "File not found: $FILE"
    exit 1
  fi
  
  # Check if output file is specified
  if [ -z "$OUTPUT_FILE" ]; then
    echo "Error: Output file must be specified for decryption"
    echo "Usage: $0 decrypt <encrypted-file> <output-file>"
    exit 1
  fi
  
  # Decrypt file
  echo "Decrypting $FILE to $OUTPUT_FILE..."
  gcloud kms decrypt \
    --location=us-central1 \
    --keyring=sops-keyring \
    --key=sops-key \
    --ciphertext-file="$FILE" \
    --plaintext-file="$OUTPUT_FILE"
  
  echo "Decryption complete. File decrypted to $OUTPUT_FILE"

else
  echo "Invalid action: $ACTION"
  echo "Usage: $0 encrypt <file>"
  echo "       $0 decrypt <encrypted-file> <output-file>"
  exit 1
fi
