#!/bin/bash

# Exit immediately if a command fails
set -e

# Source docker helpers
if [ -f "./weave/helpers/docker.sh" ]; then
    source ./weave/helpers/docker.sh
else
    echo -e "\e[31m$SERVICE_NAME: Cannot find 'docker' file! Exiting...\e[0m"
    exit 1
fi

# Prepare docker
echo -e "\e[33m$SERVICE_NAME: Preparing docker...\e[0m"
check_docker
echo -e "\e[33m$SERVICE_NAME: Docker is ready.\e[0m"

# Stop existing containers
echo -e "\e[33m$SERVICE_NAME: Stopping existing containers...\e[0m"
docker-compose down
echo -e "\e[33m$SERVICE_NAME: Stopped existing containers.\e[0m"

# Remove unused networks
echo -e "\e[33m$SERVICE_NAME: Removing unused networks...\e[0m"
remove_networks
echo -e "\e[33m$SERVICE_NAME: Removed unused networks.\e[0m"

# Cleaning up unused Docker images
echo -e "\e[33m$SERVICE_NAME: Cleaning up unused Docker images...\e[0m"
docker system prune -af
echo -e "\e[33m$SERVICE_NAME: Cleaned up unused Docker images.\e[0m"
