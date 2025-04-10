#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script provides utility helper functions for a weave service.

# Function: prepare_service
# Purpose: Set the service environment variables
# Arguments: None
# Returns: None
# Usage: prepare_service
prepare_service() {
    export SERVICE_NAME=$(basename "$PWD") > /dev/null 2>&1

    # Check if the service environment file exists
    if [[ ! -f ".env" ]]; then
        echo -e "\e[31m$SERVICE_NAME: No environment file found...\e[0m"
        exit 1
    fi

    source .env
}

# Function: log_service_script_usage
# Purpose: Log the usage of the service script
# Arguments:
#   None
# Returns:
#   None
# Usage: log_service_script_usage
log_service_script_usage() {
    echo -e "\e[33mUsage: ./weave.sh <run|kill|update|backup-task|log-available-ports>\e[0m"
    echo -e "\e[33mOptions available:\e[0m"
    echo -e "\e[33mDevelopment mode: -d|-dev\e[0m"
    echo -e "\e[94mSee weave default-service readme: https://github.com/nicolas-tdc/weave-core/blob/main/default-service/README.md\e[0m"
}