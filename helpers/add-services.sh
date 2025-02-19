#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

cd $APP_NAME

# Add services
while true; do
    # Service name input
    echo -e "Enter your service's name - Enter 'stop' to end (default: 'service'): \c"
    read SERVICE_NAME
    if [ "$SERVICE_NAME" == "stop" ]; then
        break;
    fi
    SERVICE_NAME=${SERVICE_NAME:-service}
    export SERVICE_NAME

    # Create app directory
    echo -e "\e[33mCreating service directory...\e[0m"
    echo -e "SERVICE:$SERVICE_NAME"
    mkdir -p "$SERVICE_NAME"

    # Git clone service repository
    if [ -f "./helpers/git-clone.sh" ]; then
        echo -e "\e[33mCloning service...\e[0m"
        ./helpers/git-clone.sh $SERVICE_NAME "main"
    fi

    # Run app specific initialization script
    cd "$SERVICE_NAME"
    if [ -f "./scripts/init.sh" ]; then
        echo -e "\e[33mRunning service specific initialization script...\e[0m"
        "./scripts/init.sh"
    fi
    cd ".."
done