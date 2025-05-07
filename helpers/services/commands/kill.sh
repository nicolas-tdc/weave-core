#!/bin/bash

# Exit immediately if a command fails
set -e

echo -e "\e[33m$SERVICE_NAME: Trying to stop in environment '$ENV_NAME'...\e[0m"

# Prepare docker
echo -e "\e[33m$SERVICE_NAME: Preparing docker...\e[0m"
check_docker
echo -e "\e[32m$SERVICE_NAME: Docker is ready.\e[0m"

# Stop existing containers
if [ "$env_name" == "dev" ]; then
    echo -e "\e[33m$SERVICE_NAME: Stopping in development mode...\e[0m"
    docker-compose -f docker-compose.yml -f docker-compose.dev.yml down
else
    echo -e "\e[33m$SERVICE_NAME: Stopping...\e[0m"
    docker-compose down
fi
echo -e "\e[32m$SERVICE_NAME: Stopped existing containers.\e[0m"

# Remove unused networks
echo -e "\e[33m$SERVICE_NAME: Removing docker networks...\e[0m"
remove_networks
echo -e "\e[32m$SERVICE_NAME: Removed docker networks.\e[0m"

# Cleaning up unused Docker images
echo -e "\e[33m$SERVICE_NAME: Cleaning up unused Docker images...\e[0m"
docker system prune -af
echo -e "\e[32m$SERVICE_NAME: Cleaned up unused Docker images.\e[0m"
