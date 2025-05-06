#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script contains logs helper functions for the weave application.

# Function: log_service_usage
# Purpose: Log the usage of the service script
# Arguments:
#   None
# Returns:
#   None
# Usage: log_service_usage
log_service_usage() {
    echo -e "\e[33mUsage: ./weave.sh <run|kill|backup-task|log-available-ports>\e[0m"
    echo -e "\e[33mOptions available:\e[0m"
    echo -e "\e[33mDevelopment mode: -d | -dev\e[0m"
    echo -e "\e[33mStaging mode: -s | -staging\e[0m"
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