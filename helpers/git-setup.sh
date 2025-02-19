#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Input ssh private key path
echo -e "Enter your ssh public key path (default: '~/.ssh/id_rsa'): \c"
read SSH_PRIVATE_KEY_PATH
SSH_PRIVATE_KEY_PATH=${SSH_PRIVATE_KEY_PATH:-~/.ssh/id_rsa}

# Setup ssh agent
eval "$(ssh-agent -s)"
export SSH_AUTH_SOCK
ssh-add "$SSH_PRIVATE_KEY_PATH"