#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script contains environment helper functions for the weave application.

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

    # Setup services directory
    export SERVICES_DIRECTORY="services"
    mkdir -p $SERVICES_DIRECTORY > /dev/null 2>&1

    # Setup backup directory
    export BACKUP_DIRECTORY="backups"
    mkdir -p $BACKUP_DIRECTORY > /dev/null 2>&1
}
