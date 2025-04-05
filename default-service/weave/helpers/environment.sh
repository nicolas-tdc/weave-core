#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script provides utility helper functions for a weave service.

# Function: set_service_environment
# Purpose: Set the service environment variables
# Arguments: None
# Returns: None
# Usage: set_service_environment
set_service_environment() {
    export SERVICE_NAME=$(basename "$PWD") > /dev/null 2>&1

    # Check if the service environment file exists
    if [[ ! -f ".env" ]]; then
        echo -e "\e[31m$SERVICE_NAME: No environment file found...\e[0m"
        exit 1
    fi

    source .env
}
