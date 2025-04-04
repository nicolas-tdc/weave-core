#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script provides utility helper functions for a weave service.

# Function: set_service_environment
# Purpose: Set the service environment variables
# Arguments: None
# Returns: None
# Usage: set_service_environment
set_service_environment() {
    export SERVICE_NAME=$(basename "$PWD") > /dev/null 2>&1

    # Check if the service environment file exists
    if [[ ! -f ".env" ]]; then
        echo -e "\e[31m$SERVICE_NAME: No environment file found...\e[0m"
        exit 1
    fi

    source .env
}

# Function: install_packages
# Purpose: Install required packages if not already installed
# Arguments:
#   $@ - List of package names to check and install
# Returns: None
# Usage:
#   install_packages <package1> <package2> ...
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
        echo -e "\e[33mInstalling missing packages...\e[0m"
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

# Function: is_number
# Purpose: Check if a string is a number
# Arguments:
#   $1 - The string to check
# Returns:
#   0 if the string is a number, 1 otherwise
# Usage:
#   is_number <input_string>
is_number() {
    [[ "$1" =~ ^[0-9]+$ ]] && return 0 || return 1
}