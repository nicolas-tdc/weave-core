#!/bin/bash

# Exit immediately if a command fails
set -e

# This script is used to start the service

# Source utilities helpers
if [ -f "./weave-service/helpers/utils.sh" ]; then
    source ./weave-service/helpers/utils.sh
else
    echo -e "\e[31m$SERVICE_NAME: Cannot find 'utils' helper file. Exiting...\e[0m"
    exit 1
fi

# Source docker helpers
if [ -f "./weave-service/helpers/docker.sh" ]; then
    source ./weave-service/helpers/docker.sh
else
    echo -e "\e[31m$SERVICE_NAME: Cannot find 'docker' helper file. Exiting...\e[0m"
    exit 1
fi

env_name="$1"

echo -e "\e[33m$SERVICE_NAME: Trying to start in environment '$env_name'...\e[0m"

# Prepare docker
echo -e "\e[33m$SERVICE_NAME: Preparing docker...\e[0m"
check_docker
create_networks
echo -e "\e[32m$SERVICE_NAME: Docker is ready.\e[0m"

# Stop existing containers
echo -e "\e[33m$SERVICE_NAME: Stopping existing containers...\e[0m"
docker-compose down > /dev/null 2>&1
echo -e "\e[32m$SERVICE_NAME: Stopped existing containers.\e[0m"

# Build and start containers
if [ "$env_name" == "dev" ]; then
    echo -e "\e[33m$SERVICE_NAME: Starting in development mode...\e[0m"
    docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build --remove-orphans -d
else
    echo -e "\e[33m$SERVICE_NAME: Starting...\e[0m"
    docker-compose up --build --remove-orphans -d
fi
echo -e "\e[32m$SERVICE_NAME: Container started.\e[0m"

# Clean up unused Docker images
echo -e "\e[33m$SERVICE_NAME: Cleaning up unused Docker images...\e[0m"
docker system prune -af
echo -e "\e[32m$SERVICE_NAME: Unused Docker images cleaned up.\e[0m"

echo -e "\e[32m$SERVICE_NAME: Service started successfully.\e[0m"