#!/bin/bash
# Script to load aliases into current shell

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Loading aliases from $SCRIPT_DIR/.bashrc-aliases..."
source "$SCRIPT_DIR/.bashrc-aliases"
echo "Aliases loaded successfully!"
echo "Run 'showalias' to see all available aliases" 