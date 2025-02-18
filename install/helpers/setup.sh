#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

apt update

# Check if Git is installed
if ! command -v git >/dev/null 2>&1; then
    # Install docker
    echo -e "\e[33mInstalling git..."
    apt install -y git
fi

# Check if Docker is installed
if ! command -v docker >/dev/null 2>&1; then
    # Install docker
    echo -e "\e[33mInstalling docker..."
    apt install -y docker
fi

# Check if Docker Compose is installed
if ! command -v docker-compose >/dev/null 2>&1; then
    # Install docker
    echo -e "\e[33mInstalling docker compose..."
    apt install -y docker-compose
fi

# Check if user is in Docker group
if ! groups "$USER" | grep -q "\bdocker\b"; then
    # Add user to Docker group
    echo -e "\e[33mAdding user to Docker group...\e[0m"
    usermod -aG docker $USER
fi