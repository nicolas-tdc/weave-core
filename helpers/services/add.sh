#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Add services
while true; do
    # Service name input
    echo -e "Enter your service's name - Enter 'stop' to end (default: 'service'): \c"
    read SERVICE_NAME
    # End add services
    if [ "$SERVICE_NAME" == "stop" ]; then
        break;
    fi
    # Check if service name already used
    if [ -d "./$APP_NAME/$SERVICE_NAME" ]; then
        echo -e "\e[31mService name already used.\e[0m"
        continue;
    fi
    SERVICE_NAME=${SERVICE_NAME:-service}
    export SERVICE_NAME

    if [ -f "./helpers/services/clone-repository.sh" ]; then
        echo -e "\e[33mFormatting service's docker-compose.yml file...\e[0m"
        ./helpers/services/clone-repository.sh
    fi

    # Copy service scripts
    (
        if [ -f "./helpers/services/copy-scripts.sh" ]; then
            echo -e "\e[33mCopying scripts to service...\e[0m"
            ./helpers/utils/copy-directory-files.sh "./to-services/*" "./$APP_NAME/$SERVICE_NAME"
        fi
    ) &
    # Format service environment variables and docker-compose file
    (
        if [ -f "./helpers/services/format-docker-compose.sh" ]; then
            echo -e "\e[33mFormatting service's docker-compose.yml file...\e[0m"
            ./helpers/services/format-docker-compose.sh
        fi
    ) &

    wait
    echo -e "\e[32mService added successfully!\e[0m"
done