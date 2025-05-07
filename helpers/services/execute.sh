#!/bin/bash

# Exit immediately if a command fails
set -e

# This script contains helper functions for managing weave services.

# Function: execute_service_command_script
# Purpose: Executes a script on a specific service.
# Arguments:
#   1. script_path: The path to the script to execute.
#   @. script_args: Additional arguments for the script.
# Returns:
#   None
# Usage: execute_service_command_script <script_path> [<script_args>...]
execute_service_command_script() {
    if [ -z "$1" ]; then
        echo -e "\e[31mexecute_service_command_script() - Error: First argument is required.\e[0m"
        echo -e "\e[33musage: execute_service_command_script <services_directory> <command_name>\e[0m"
        exit 1
    fi

    local script_path=$1
    local service_path=$2
    shift 2

    # Execute command on the specific service
    if [ -d "$service_path" ] && [ -f "${service_path}/weave.sh" ]; then
        cd "$service_path"
        source "$script_path" "$@"
        cd - > /dev/null 2>&1
    else
        echo -e "\e[31mService '$SERVICE_NAME' not found or missing main weave script.\e[0m"
        exit 1
    fi
}

# Function: execute_command
# Purpose: Executes a command on all services or a specific service.
# Arguments:
#   1. command_name: The name of the command to execute.
#   @. command_args: Additional arguments for the command.
# Returns:
#   None
# Usage: execute_command <command_name> [<args>...]
execute_command() {
    if [ -z "$1" ]; then
        echo -e "\e[31mexecute_command() - Error: First argument is required.\e[0m"
        echo -e "\e[33musage: execute_command <command_name> [<args>...]\e[0m"
        exit 1
    fi

    local command_name=$1
    shift 1

    script_relative_path="./weave-core/helpers/services/commands/$command_name.sh"
    script_path="$(cd "$(dirname "$script_relative_path")" && pwd)/$(basename "$script_relative_path")"

    if [ "$SERVICE_NAME" == "" ]; then
        echo -e "\e[33mTrying to $command_name application '$APP_NAME'...\e[0m"

        for service_path in $SERVICES_DIRECTORY/*/; do
            SERVICE_NAME=$(basename "$service_path")

            execute_service_command_script \
                $script_path \
                "$SERVICES_DIRECTORY/$SERVICE_NAME" \
                $@
        done
    else
        echo -e "\e[33mTrying to $command_name service '$SERVICE_NAME'...\e[0m"

        execute_service_command_script \
            $script_path \
            "$SERVICES_DIRECTORY/$SERVICE_NAME" \
            $@

    fi
}