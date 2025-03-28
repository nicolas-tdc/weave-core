#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

set_service_environment() {
    export SERVICE_NAME=$(basename "$PWD") > /dev/null 2>&1

    # Check if the service environment file exists
    if [[ ! -f ".env" ]]; then
        echo -e "\e[31m$SERVICE_NAME: No environment file found...\e[0m"
        exit 1
    fi

    # Check if the docker-compose file exists
    if [[ ! -f "docker-compose.yml" ]]; then
        echo -e "\e[31m$SERVICE_NAME: No docker-compose.yml file...\e[0m"
        exit 1
    fi

    source .env
}
