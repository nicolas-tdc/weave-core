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

# Source docker helpers
if [ -f "./weave/helpers/docker.sh" ]; then
    source ./weave/helpers/docker.sh
else
    echo -e "\e[31m$SERVICE_NAME|$APP_ENV: Cannot find 'docker' file! Exiting...\e[0m"
    exit 1
fi

is_standalone=$([ "$0" = "$BASH_SOURCE" ] && echo false || echo true)

if [ "$is_standalone" = true ]; then
    echo -e "\e[33m$SERVICE_NAME|$APP_ENV: Trying to start in standalone mode...\e[0m"
else
    echo -e "\e[33m$SERVICE_NAME|$APP_ENV: Trying to start...\e[0m"
fi

set_service_environment $1
create_networks

# Stopping existing containers
echo -e "\e[33m$SERVICE_NAME|$APP_ENV: Stopping existing containers...\e[0m"
docker-compose down > /dev/null 2>&1

# Building and starting containers
echo -e "\e[33m$SERVICE_NAME|$APP_ENV: Building and starting container...\e[0m"
docker-compose up --build --remove-orphans -d

# Cleaning up unused Docker images
echo -e "\e[33m$SERVICE_NAME|$APP_ENV: Cleaning up unused Docker images...\e[0m"
docker system prune -af

# Log available ports if in standalone mode
if [ "$is_standalone" = true ]; then
    echo -e "\e[33m$SERVICE_NAME|$APP_ENV: Logging available ports...\e[0m"
    log_available_ports $SERVICE_NAME
fi
