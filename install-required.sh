#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

sudo apt update

# Check if Git is installed
if ! command -v git >/dev/null 2>&1; then
    # Install git
    echo -e "\e[33mInstalling git...\e[0m"
    sudo apt install -y git
fi
