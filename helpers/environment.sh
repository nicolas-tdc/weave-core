#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script contains environment helper functions for the weave application.

# Function: prepare_application
# Purpose: Prepare the application by creating necessary directories
# Arguments: None
# Returns:
#   1. app_name: The name of the application
#   2. services_directory: The directory for services
#   3. backups_directory: The directory for backups
# Usage: prepare_application
#   prepare_application
prepare_application() {
    # Get app name from directory name
    local app_name=$(basename "$PWD") > /dev/null 2>&1

    # Setup services directory
    local services_directory="services"
    mkdir -p $services_directory > /dev/null 2>&1

    # Setup backup directory
    local backups_directory="backups"
    mkdir -p $backups_directory > /dev/null 2>&1

    # Return parsed arguments and options
    echo "$app_name" "$services_directory" "$backups_directory"
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

    # Copy the environment-specific file to .env
    if ! [ -f ".env.$ENV_NAME" ]; then
        echo -e "\e[31mError: Environment specific file '.env.$ENV_NAME' not found.\e[0m"
        exit 1
    fi

    cp -f ".env.$ENV_NAME" ".env"
    source .env
}
