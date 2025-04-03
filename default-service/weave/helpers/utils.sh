#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

set_service_environment() {
    export SERVICE_NAME=$(basename "$PWD") > /dev/null 2>&1

    # Check if the service environment file exists
    if [[ ! -f ".env" ]]; then
        echo -e "\e[31m$SERVICE_NAME: No environment file found...\e[0m"
        exit 1
    fi

    source .env
}

# This function installs apt packages listed as function arguments
# usage :
# install_packages <first-package> <second-package> ...
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
    else
        echo -e "\e[32mAll packages are already installed.\e[0m"
    fi
}