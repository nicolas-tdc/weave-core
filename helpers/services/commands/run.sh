#!/bin/bash

# Exit immediately if a command fails
set -e

# This script is used to start the service

echo -e "\e[33m$SERVICE_NAME: Trying to start in environment '$ENV_NAME'...\e[0m"

if ! [ -f "docker-compose.yml" ]; then
    echo -e "\e[31m$SERVICE_NAME: Cannot find docker-compose.yml file. Exiting...\e[0m"
    exit 1
fi

if ! [ -f ".env" ]; then
    echo -e "\e[31m$SERVICE_NAME: Cannot find .env file. Exiting...\e[0m"
    exit 1
fi

# Prepare docker
echo -e "\e[33m$SERVICE_NAME: Preparing docker...\e[0m"
check_docker
create_networks
docker-compose down > /dev/null 2>&1
echo -e "\e[32m$SERVICE_NAME: Docker is ready.\e[0m"

# Up docker-compose
if [ -f "docker-compose.$ENV_NAME.yml" ]; then
    echo -e "\e[33m$SERVICE_NAME: Starting in '$ENV_NAME'...\e[0m"
    docker-compose -f docker-compose.yml -f docker-compose.$ENV_NAME.yml up --build --remove-orphans -d
else
    echo -e "\e[33m$SERVICE_NAME: Starting...\e[0m"
    docker-compose up --build --remove-orphans -d
fi
echo -e "\e[32m$SERVICE_NAME: Container started.\e[0m"

# Clean up unused Docker images
docker system prune -af

echo -e "\e[32m$SERVICE_NAME: Service started successfully.\e[0m"