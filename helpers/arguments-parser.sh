#!/bin/bash

# Exit immediately if a command fails
set -e

# This script contains command arguments parsing functions.

# Function: parse_command_arguments
# Purpose: Parse command line arguments and set environment and service names
# Arguments:
#   @. command line arguments
# Returns:
#   None
# Usage: parse_command_arguments [--s=<service_name>] [-dev] [-staging]
# Note: This function is used to parse command line arguments and set the environment name and service name.
# It is not intended to be called directly.
parse_command_arguments() {
    # This function parses command line arguments and sets the environment name and service name.

    # Default values
    ENV_NAME="prod"
    SERVICE_NAME=""

    # Parse arguments to extract options
    while [[ $# -gt 0 ]]; do
        case "$1" in
            # Extract service name from argument
            --s=*)
                SERVICE_NAME="${1#*=}"
                shift
                ;;
            # Development environment
            -dev)
                ENV_NAME="dev"
                shift
                ;;
            # Staging environment
            -staging)
                ENV_NAME="staging"
                shift
                ;;
            # Default case for unrecognized arguments
            *)
                shift
                ;;
        esac
    done

    export ENV_NAME
    export SERVICE_NAME
}
