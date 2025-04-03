#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

set_application_environment() {
    # Get app name from directory name
    export APP_NAME=$(basename "$PWD") > /dev/null 2>&1

    # Check if the deploy-sk .env file exists
    if ! [ -f "./.env" ]; then
        echo -e "\e[31m$APP_NAME: Error! .env file not found in the application's directory.\e[0m"
        exit 1
    fi

    # Get development environment variables
    echo -e "\e[33m$APP_NAME: Getting environment variables...\e[0m"
    source .env

}
