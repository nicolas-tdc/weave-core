#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script contains environment helper functions for the weave application.

# Function: prepare_environment_files
# Purpose: Prepare the environment specific files
# Arguments:
#   1. environment_name: The name of the environment to prepare
# Returns: None
# Usage: prepare_environment_files <environment_name>
# Notes: This function will copy the environment-specific file to .env and source it.
prepare_environment_files() {
    if [ -z "$1" ]; then
        echo -e "\e[31mprepare_environment_files() - Error: First argument is required.\e[0m"
        echo -e "\e[31musage: prepare_environment_files <environment_name>\e[0m"
        exit 1
    fi

    # Check if the environment file exists
    if ! [ -f ".env.$ENV_NAME" ]; then
        echo -e "\e[31mError: Environment specific file '.env.$ENV_NAME' not found.\e[0m"
        exit 1
    fi

    # Copy the environment-specific file to .env
    cp -f ".env.$ENV_NAME" ".env"
    source .env
}
