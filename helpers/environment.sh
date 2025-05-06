#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script contains environment helper functions for the weave application.

# Function: prepare_application
# Purpose: Set the application environment variables from the .env file
# Arguments:
#   None
# Returns:
#   None
# Usage: prepare_application
prepare_application() {
    # Get app name from directory name
    export APP_NAME=$(basename "$PWD") > /dev/null 2>&1

    # Setup services directory
    export SERVICES_DIRECTORY="services"
    mkdir -p $SERVICES_DIRECTORY > /dev/null 2>&1

    # Setup backup directory
    export BACKUP_DIRECTORY="backups"
    mkdir -p $BACKUP_DIRECTORY > /dev/null 2>&1
}

# Function: prepare_environment_files
# Purpose: Prepare the environment specific files
# Arguments:
#   1. environment_name: The name of the environment to prepare
# Returns: None
# Usage: prepare_environment_files <environment_name>
prepare_environment_files() {
    if [ -z "$1" ]; then
        echo -e "\e[31mprepare_environment_files() - Error: First argument is required.\e[0m"
        echo -e "\e[31musage: prepare_environment_files <environment_name>\e[0m"
        exit 1
    fi

    local env_name=$1

    # Copy the environment-specific file to .env
    if ! [ -f ".env.$env_name" ]; then
        echo -e "\e[31mError: Environment specific file '.env.$env_name' not found.\e[0m"
        exit 1
    fi

    cp -f ".env.$env_name" ".env"
    source .env
}
