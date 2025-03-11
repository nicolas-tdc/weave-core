#!/bin/bash

# Exit immediately if a command fails
set -e

# Copy environment and docker-compose files
if [ -f "./weave/helpers/set-environment.sh" ]; then
    source ./weave/helpers/set-environment.sh $1
fi

# Stopping existing containers
echo -e "\e[33m$SERVICE_NAME: Stopping existing containers...\e[0m"
docker-compose down > /dev/null 2>&1

# Format docker-compose file if not in standalone mode
if [ -f "./weave/helpers/format-docker-compose.sh" ] && [ "$0" == "$BASH_SOURCE" ]; then
    ./weave/helpers/format-docker-compose.sh
fi

echo -e "\e[32m$SERVICE_NAME: Docker and files ready!\e[0m"

# Building and starting containers
echo -e "\e[33m$SERVICE_NAME: Building and starting container...\e[0m"
docker-compose up --build --remove-orphans -d

# Cleaning up unused Docker images
echo -e "\e[33m$SERVICE_NAME: Cleaning up unused Docker images...\e[0m"
docker system prune -af

# Log available ports if in standalone mode
if [ -f "./weave/helpers/log-available-ports.sh" ] && ! [ "$0" == "$BASH_SOURCE" ]; then
    ./weave/helpers/log-available-ports.sh
fi
