#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script provides utility helper functions for a weave service.

# Function: install_packages
# Purpose: Install required packages if not already installed
# Arguments:
#   $@ - List of package names to check and install
# Returns: None
# Usage:
#   install_packages <package1> <package2> ...
# Notes: This function checks if the specified packages are installed and installs them if they are not.
# It also runs `apt autoremove` after installation to clean up unnecessary packages.
install_packages() {
    # Define required packages
    packages=("$@")

    # Check if a package is installed
    is_installed() {
        dpkg -l | grep -q "^ii  $1 "
    }

    # Check for missing packages
    needs_update=false
    for pkg in "${packages[@]}"; do
        if ! is_installed "$pkg"; then
            needs_update=true
            break;
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
    fi
}