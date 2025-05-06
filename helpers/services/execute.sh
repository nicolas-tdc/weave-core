#!/bin/bash

# Exit immediately if a command fails
set -e

# This script contains helper functions for managing weave services.

# Function: execute_command_on_all_services
# Purpose: Executes a command on all services in the specified directory.
# Arguments:
#   1. services_directory: The directory containing the services.
#   2. command_name: The name of the command to execute.
#   @. service_command_args: Additional arguments for the service command.
# Returns:
#   None
# Usage: execute_command_on_all_services <services_directory> <command_name> [<service_command_args>...]
execute_command_on_all_services() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "\e[31mexecute_command_on_all_services() - Error: First and second argument are required.\e[0m"
        echo -e "\e[33musage: execute_command_on_all_services <services_directory> <command_name>\e[0m"
        exit 1
    fi

    local services_directory=$1
    local command_name=$2
    shift 2

    # Additional arguments for the service command

    for service_path in $services_directory/*/; do
        # Check if it's a directory
        if [ -d "$service_path" ] && [ -f "${service_path}weave.sh" ]; then
            cd "$service_path"
            ./weave.sh "$command_name" "$@"
            cd - > /dev/null 2>&1
        fi
    done
}

# Function: execute_command_on_specific_service
# Purpose: Executes a command on a specific service in the specified directory.
# Arguments:
#   1. services_directory: The directory containing the services.
#   2. command_name: The name of the command to execute.
#   3. service_name: The name of the service to execute the command on.
#   @. service_command_args: Additional arguments for the service command.
# Returns:
#   None
# Usage: execute_command_on_specific_service <services_directory> <command_name> <service_name> [<service_command_args>...]
execute_command_on_specific_service() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo -e "\e[31mexecute_command_on_specific_service() - Error: First and second argument are required.\e[0m"
        echo -e "\e[31musage: execute_command_on_specific_service <services_directory> <command_name> <service_name>\e[0m"
        exit 1
    fi

    local services_directory=$1
    local command_name=$2
    local service_name=$3
    shift 3

    local service_path="$services_directory/$service_name"

    # Execute command on the specific service
    if [ -d "$service_path" ] && [ -f "${service_path}/weave.sh" ]; then
        cd "$service_path"
        ./weave.sh "$command_name" "$@"
        cd - > /dev/null 2>&1
    else
        echo -e "\e[31mService '$service_name' not found or missing main weave script.\e[0m"
        exit 1
    fi
}
