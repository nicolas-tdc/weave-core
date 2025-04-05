#!/bin/bash

# Exit immediately if a command fails
set -e

# This script contains helper functions for managing weave services.

# Function: install_service
# Purpose: Configures weave services by adding them to the specified directory and formatting their Docker Compose files.
# Arguments:
#   1. services_directory: The directory where the services will be added.
#   2. weave_services_directory: The directory containing available weave services.
# Returns:
#   None
# Usage: install_service <services_directory> <weave_services_directory>
install_service() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "\e[31minstall_service() - Error: First and second argument are required.\e[0m"
        echo -e "\e[31musage: install_service <services_directory> <weave_services_directory>\e[0m"
        exit 1
    fi

    local services_directory=$1
    local weave_services_directory=$2

    # Get available services list
    local available_services=()
    for service_dir in "$weave_services_directory"/*; do
        if [ -d "$service_dir" ]; then
            available_services+=("$(basename "$service_dir")")
        fi
    done

    # Select service
    echo -e "\e[94mPlease select a service to add to your app:\e[0m"
    select selected_service in "${available_services[@]}"; do
        if [[ -n $selected_service ]]; then
            # Get the service name from the selected directory
            local available_service_name=$(basename "$selected_service")

            break;
        else
            echo "\e[31mInvalid selection, please try again.\e[0m"
        fi
    done

    # Service name
    while true; do
        echo -e "\e[94mEnter your service's name (default: '$available_service_name'):\e[0m"
        read service_name
        local service_name=${service_name:-"$available_service_name"}

        # Check if service directory already exists
        if ! [ -d "./$services_directory/$service_name" ]; then
            break;
        fi

        echo -e "\e[31mService name '$service_name' already used.\e[0m"
        continue;
    done

    # Copy selected service to named service directory
    cp -r "$weave_services_directory/$selected_service" "$services_directory/$service_name"

    # Remove git remote
    rm -rf "$services_directory/$service_name/.git"

    # Format docker-compose files
    local compose_file="$services_directory/$service_name/docker-compose.yml"
    if [ -f "$compose_file" ]; then
        echo -e "\e[33m$service_name: Formatting docker-compose.yml file...\e[0m"
        format_docker_compose $service_name $compose_file "${APP_NAME}_network"
    fi

    if [ -d "./weave/default-service" ] && [ -d "$services_directory/$service_name" ]; then
        # Copy default service files to service's directory
        sudo cp -r ./weave/default-service/* "$services_directory/$service_name"
        # Set permissions
        sudo chmod -R 755 "$services_directory/$service_name"
        sudo chown -R "$USER:$USER" "$services_directory/$service_name"
    fi

    echo -e "\e[32mService $service_name added successfully.\e[0m"
}

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
    local service_command_args=("$@")

    for service_path in $services_directory/*/; do
        # Check if it's a directory
        if [ -d "$service_path" ] && [ -f "${service_path}weave.sh" ]; then
            cd "$service_path"
            ./weave.sh "$command_name" "${service_command_args[@]}"
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
    
    # Additional arguments for the service command
    local service_command_args=("$@")

    local service_path="$services_directory/$service_name"

    # Execute command on the specific service
    if [ -d "$service_path" ] && [ -f "${service_path}/weave.sh" ]; then
        cd "$service_path"
        ./weave.sh "$command_name" "${service_command_args[@]}"
        cd - > /dev/null 2>&1
    else
        echo -e "\e[31mService '$service_name' not found or missing main weave script.\e[0m"
        exit 1
    fi
}
