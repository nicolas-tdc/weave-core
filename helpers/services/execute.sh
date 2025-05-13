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
    if [ -d "$service_path" ]; then
        cd "$service_path"
        if ! [ -f ".env.$ENV_NAME" ]; then
            echo -e "\e[31m$SERVICE_NAME: '.env.$ENV_NAME' not found.\e[0m"
            exit 1
        fi

        cp ".env.$ENV_NAME" ".env" > /dev/null 2>&1
        source "$script_path" "$@"
        cd - > /dev/null 2>&1
    else
        echo -e "\e[31m$SERVICE_NAME: Not found in $service_path.\e[0m"
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
        # Execute on all services
        echo -e "\e[33m$APP_NAME: Trying to $command_name...\e[0m"

        get_installed_services
        for key in "${INSTALLED_SERVICE_KEYS[@]}"; do
            # Sleep option
            if [ $key == "sleep" ]; then
                if [ $command_name == "run" ]; then
                    echo -e "\e[33m$APP_NAME: Sleeping for ${INSTALLED_SERVICES[$key]} seconds...\e[0m"
                    sleep ${INSTALLED_SERVICES[$key]}
                fi

                continue
            fi

            SERVICE_NAME=$key
            local service_path="$SERVICES_DIRECTORY/$SERVICE_NAME"

            # Check if the service is installed
            if ! [ -d "$service_path" ]; then
                echo -e "\e[31mService '$SERVICE_NAME' not found in '$SERVICES_DIRECTORY'.\e[0m"
                continue
            fi

            execute_service_command_script \
                $script_path \
                $service_path \
                $@
        done
    else
        echo -e "\e[33m$APP_NAME: Trying to $command_name service '$SERVICE_NAME'...\e[0m"

        local service_path="$SERVICES_DIRECTORY/$SERVICE_NAME"

        # Check if the service is installed
        if ! [ -d "$service_path" ]; then
            echo -e "\e[31mService '$SERVICE_NAME' not found in '$SERVICES_DIRECTORY'.\e[0m"
            exit 1
        fi

        execute_service_command_script \
            $script_path \
            $service_path \
            $@
    fi
}