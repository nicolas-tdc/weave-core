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

    # Git clone service repository
    if [ -f "./helpers/git/clone.sh" ]; then
        ./helpers/git/clone.sh "$APP_NAME/$SERVICE_NAME" "main"
    fi

    # Check if service contains necessary files
    if ! [ -f "./$APP_NAME/$SERVICE_NAME/.env.dist" ] || ! [ -f "./$APP_NAME/$SERVICE_NAME/docker-compose.yml" ]; then
        echo -e "\e[31mInvalid service: missing .env.dist or docker-compose.yml file!e\0m]"
        echo -e "\e[33mRemoving service...e\0m]"
        rm -rf "./$APP_NAME/$SERVICE_NAME"
        continue;
    fi

    # Format service environment variables and docker-compose file
    if [ -f "./helpers/services/format-docker-compose.sh" ]; then
        echo -e "\e[33mFormatting service's docker-compose.yml file...\e[0m"
        ./helpers/services/format-docker-compose.sh
    fi

    # Set service's specific scripts permissions
    if [ -d "./$APP_NAME/$SERVICE_NAME/scripts" ]; then
        chmod -R 755 "./$APP_NAME/$SERVICE_NAME/scripts"
    fi

    # Run service's specific initialization script
    prev_dir=$(pwd)
    cd "$APP_NAME/$SERVICE_NAME"
    if [ -d "./scripts" ] && [ -f "./scripts/init.sh" ]; then
        echo -e "\e[33mRunning service specific initialization script...\e[0m"
        "./scripts/init.sh"
    fi
    cd $prev_dir
done