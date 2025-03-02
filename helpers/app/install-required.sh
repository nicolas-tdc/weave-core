#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

sudo apt update

# Check if Git is installed
if ! command -v git >/dev/null 2>&1; then
    # Install docker
    echo -e "\e[33mInstalling git...\e[0m"
    sudo apt install -y git
fi

# Check if Docker is installed
if ! command -v docker >/dev/null 2>&1; then
    # Install docker
    echo -e "\e[33mInstalling docker...\e[0m"
    sudo apt install -y docker
fi

# Check if Docker Compose is installed
if ! command -v docker-compose >/dev/null 2>&1; then
    # Install docker
    echo -e "\e[33mInstalling docker compose...\e[0m"
    sudo apt install -y docker-compose
fi
