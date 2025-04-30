#!/bin/bash

# Exit immediately if a command fails
set -e

# This script contains command arguments parsing functions.

parse_command_arguments() {
    # This function parses command line arguments and sets the environment name and service name.

    # Default values
    env_name="prod"
    service_name=""

    # Parse arguments to extract options
    app_script_args=()
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
