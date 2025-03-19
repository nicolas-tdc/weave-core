#!/bin/bash

# Exit immediately if a command fails
set -e

# Source utilities helpers
if [ -f "./weave/helpers/utils.sh" ]; then
    source ./weave/helpers/utils.sh
else
    echo -e "\e[31m$SERVICE_NAME|$APP_ENV: Cannot find 'utils' file! Exiting...\e[0m"
    exit 1
fi

set_service_environment $1

# Stopping existing containers
echo -e "\e[33m$$SERVICE_NAME|$APP_ENV: Stopping existing containers...\e[0m"
docker-compose down

# Cleaning up unused Docker images
echo -e "\e[33m$$SERVICE_NAME|$APP_ENV: Cleaning up unused Docker images...\e[0m"
docker system prune -af
