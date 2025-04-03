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

echo -e "\e[33m$SERVICE_NAME: Trying to start...\e[0m"

create_networks

# Stopping existing containers
echo -e "\e[33m$SERVICE_NAME: Stopping existing containers...\e[0m"
docker-compose down > /dev/null 2>&1

# Building and starting containers
echo -e "\e[33m$SERVICE_NAME: Building and starting container...\e[0m"
docker-compose up --build --remove-orphans -d

# Cleaning up unused Docker images
echo -e "\e[33m$SERVICE_NAME: Cleaning up unused Docker images...\e[0m"
docker system prune -af
