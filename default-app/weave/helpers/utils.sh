#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script contains utility functions for the weave application.

# Function: set_application_environment
# Purpose: Set the application environment variables from the .env file
# Arguments:
#   None
# Returns:
#   None
# Usage: set_application_environment
set_application_environment() {
    # Get app name from directory name
    export APP_NAME=$(basename "$PWD") > /dev/null 2>&1

    # Check if the application .env file exists
    if ! [ -f "./.env" ]; then
        echo -e "\e[31m$APP_NAME: Error! .env file not found in the application's directory.\e[0m"
        exit 1
    fi

    source .env
}
