#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define required packages
packages=("git" "docker" "docker-compose")

# Check if a package is installed
is_installed() {
    dpkg -l | grep -q "^ii  $1 "
}

# Check for missing packages
needs_update=false
for pkg in "${packages[@]}"; do
    if ! is_installed "$pkg"; then
        needs_update=true
        break
    fi
done

# If at least one package is missing, update and install
if [ "$needs_update" = true ]; then
    sudo apt update
    for pkg in "${packages[@]}"; do
        if ! is_installed "$pkg"; then
            echo -e "\e[33mInstalling $pkg...\e[0m"
            sudo apt install -y "$pkg"
        fi
    done
    sudo apt autoremove
else
    echo -e "\e[32mAll packages are already installed.\e[0m"
fi
