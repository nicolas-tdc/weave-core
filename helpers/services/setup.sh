#!/bin/bash

# Exit immediately if a command fails
set -e

# This script contains helper functions for managing weave services.

# Function: prepare_service
# Purpose: Set the service environment variables
# Arguments: None
# Returns: None
# Usage: prepare_service
prepare_service() {
    export SERVICE_NAME=$(basename "$PWD") > /dev/null 2>&1
}

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
            local service_path="$services_directory/$service_name"
            break;
        fi

        echo -e "\e[31mService name '$service_name' already used.\e[0m"
        continue;
    done

    echo -e "\e[33m$service_name: Handling weave files...\e[0m"

    # Copy selected service to named service directory
    cp -r "$weave_services_directory/$selected_service" "$service_path"

    # Remove git remote
    rm -rf "$service_path/.git"

    # Format docker-compose files
    compose_files=(
    "docker-compose.yml"
    "docker-compose.dev.yml"
    "docker-compose.staging.yml"
    "docker-compose.prod.yml"
    )
    for compose_file in "${compose_files[@]}"; do
        if [[ -f "$service_path/$compose_file" ]]; then
            format_docker_compose "$service_name" "$service_path/$compose_file"
            echo -e "\e[32m$service_name: Formatted '$compose_file' successfully.\e[0m"
        fi
    done

    echo -e "\e[32mService $service_name added successfully.\e[0m"
}
