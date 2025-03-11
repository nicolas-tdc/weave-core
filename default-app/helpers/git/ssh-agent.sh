#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[33mGit authentication using ssh-agent...\e[0m"

# Input ssh private key path
echo -e "Enter your ssh private key path (default: ~/.ssh/id_ed25519): \c"
read SSH_PRIVATE_KEY_PATH
SSH_PRIVATE_KEY_PATH=${SSH_PRIVATE_KEY_PATH:-$HOME/.ssh/id_ed25519}  # Expand tilde properly

# Expand tilde manually if it exists at the beginning
if [[ "$SSH_PRIVATE_KEY_PATH" == ~* ]]; then
    SSH_PRIVATE_KEY_PATH="${HOME}${SSH_PRIVATE_KEY_PATH:1}"
fi

# Ensure the key file exists
if [ ! -f "$SSH_PRIVATE_KEY_PATH" ]; then
    echo "Error: SSH key not found at '$SSH_PRIVATE_KEY_PATH'"
    exit 1
fi

# Setup ssh agent
eval "$(ssh-agent -s)"
export SSH_AUTH_SOCK
ssh-add "$SSH_PRIVATE_KEY_PATH"