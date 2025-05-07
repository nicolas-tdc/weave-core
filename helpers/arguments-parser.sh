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
    local env_name="prod"
    local service_name=""

    # Parse arguments to extract options
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --s=*|--service=*)
                service_name="${1#*=}"
                shift
                ;;
            -d|-dev)
                env_name="dev"
                shift
                ;;
            *)
                shift
                ;;
        esac
    done

    # Return parsed arguments and options
    echo "$env_name" "$service_name"
}
