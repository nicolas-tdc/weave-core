#!/bin/bash

# Exit immediately if a command fails
set -e

# This script contains command arguments parsing functions.

# Function: parse_command_arguments
# Purpose: Parse command line arguments and set environment and service names
# Arguments:
#   $@ - Command line arguments
# Returns:
#   ENV_NAME - The environment name (default: "prod")
#   service_name - The service name (default: "")
# Usage: parse_command_arguments "$@"
parse_command_arguments() {
    # This function parses command line arguments and sets the environment name and service name.

    # Default values
    ENV_NAME="prod"
    SERVICE_NAME=""

    # Parse arguments to extract options
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --s=*|--service=*)
                SERVICE_NAME="${1#*=}"
                shift
                ;;
            -dev)
                ENV_NAME="dev"
                shift
                ;;
            -staging)
                ENV_NAME="staging"
                shift
                ;;
            *)
                shift
                ;;
        esac
    done

    export ENV_NAME
    export SERVICE_NAME
}
