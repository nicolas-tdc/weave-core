#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define required packages
PACKAGES=("$@")

# Check if a package is installed
is_installed() {
    dpkg -l | grep -q "^ii  $1 "
}

# Check for missing packages
NEEDS_UPDATE=false
for PKG in "${PACKAGES[@]}"; do
    if ! is_installed "$PKG"; then
        NEEDS_UPDATE=true
        break
    fi
done

# If at least one package is missing, update and install
if [ "$NEEDS_UPDATE" = true ]; then
    echo -e "\e[33mInstalling missing packages...\e[0m"
    sudo apt update
    for pkg in "${PACKAGES[@]}"; do
        if ! is_installed "$PKG"; then
            echo -e "\e[33mInstalling $PKG...\e[0m"
            sudo apt install -y "$PKG"
        fi
    done
    sudo apt autoremove
else
    echo -e "\e[32mAll packages are already installed.\e[0m"
fi
