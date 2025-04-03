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

# Stopping existing containers
echo -e "\e[33m$SERVICE_NAME: Stopping existing containers...\e[0m"
docker-compose down

remove_networks

# Cleaning up unused Docker images
echo -e "\e[33m$SERVICE_NAME: Cleaning up unused Docker images...\e[0m"
docker system prune -af
