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
# Purpose: Aggregate the environment files into a single .env file
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
    if ! [ -f ".env.$env_name" ] && ! [ -f "./env-remote/.env.$env_name" ]; then
        echo -e "\e[31mError: Local and remote environment files .env.$env_name not found.\e[0m"
        exit 1
    fi

    if ! [ -f ".env.$env_name" ] && [ -f "./env-remote/.env.$env_name" ]; then
        cp "./env-remote/.env.$env_name" ".env.$env_name"
    fi

    cp -f ".env.$env_name" ".env"
    source .env
}

# Function: log_app_usage
# Purpose: Log the usage of the script
# Arguments:
#   None
# Returns:
#   None
# Usage: log_app_usage
log_app_usage() {
    echo -e "\e[33mUsage: ./weave.sh <run|kill|add-service|backup-task|backup-enable|backup-disable>\e[0m"
    echo -e "\e[33mOptions available:\e[0m"
    echo -e "\e[33mDevelopment mode: -d|-dev\e[0m"
    echo -e "\e[33mSingle service execution: --s=<service_name>|--service=<service_name>\e[0m"
    echo -e "\e[94mSee weave readme: https://github.com/nicolas-tdc/weave?tab=readme-ov-file\e[0m"
}