#!/bin/bash

# Exit immediately if a command fails
set -e

# This script contains helper functions for managing weave services.

install_service_files() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "\e[31minstall_service_files() - Error: First and second argument are required.\e[0m"
        echo -e "\e[31musage: install_service_files <service_name> <service_path>\e[0m"
        exit 1
    fi

    local service_name=$1
    local service_path=$2

    # Format docker-compose files
    compose_files=(
        "docker-compose.yml"
        "docker-compose.dev.yml"
    )
    for compose_file in "${compose_files[@]}"; do
        if [[ -f "$service_path/$compose_file" ]]; then
            format_docker_compose "$service_name" "$service_path/$compose_file"
            echo -e "\e[32m$service_name: Formatted '$compose_file' successfully.\e[0m"
        fi
    done

    # Merge service gitignore file into application gitignore file
    merge_gitignore_file \
        $service_name \
        $service_path
}

install_service() {
    # Select service from available services
    get_available_services

    echo -e "\e[94mPlease select a service to add to your app:\e[0m"
    select selected_service in "${!AVAILABLE_SERVICES[@]}"; do
        if [[ -n $selected_service ]]; then
            # Get the service name from the selected directory
            local selected_service_name=$(basename "$selected_service")
            local selected_service_url=${AVAILABLE_SERVICES["$selected_service"]}

            break;
        else
            echo "\e[31mInvalid selection, please try again.\e[0m"
        fi
    done

    # Read service name
    while true; do
        echo -e "\e[94mEnter your service's name (default: '$selected_service_name'):\e[0m"
        read service_name
        local service_name=${service_name:-"$selected_service_name"}

        # Check if service directory already exists
        if ! [ -d "./$SERVICES_DIRECTORY/$service_name" ]; then
            local service_path="$SERVICES_DIRECTORY/$service_name"
            break;
        fi

        echo -e "\e[31mService name '$service_name' already used.\e[0m"
        continue;
    done

    echo -e "\e[33m$service_name: Installing...\e[0m"

    # Clone and unlink service repository
    git clone $selected_service_url $service_path
    rm -rf "$service_path/.git"

    # Update and format service files
    install_service_files \
        $service_name \
        $service_path

    # Add service to weave services configuration file
    echo -e "$service_name=$selected_service_name" >> $WEAVE_CONFIGURATIONS_FILE

    echo -e "\e[32m$service_name: Installed successfully.\e[0m"
}

uninstall_service() {
    if [ -z "$1" ]; then
        echo -e "\e[31muninstall_service() - Error: First argument is required.\e[0m"
        echo -e "\e[31musage: uninstall_service <service_name>\e[0m"
        exit 1
    fi
    local service_name=$1

    local service_path="$SERVICES_DIRECTORY/$service_name"

    # Check if the service directory exists
    if [ ! -d "$service_path" ]; then
        echo -e "\e[31m$service_name: service directory not found in '$service_path'.\e[0m"
    else
        rm -rf $service_path
    fi

    remove_service_from_gitignore "$service_name"

    # Remove service from weave configurations file
    sed -i "/$service_name=/d" $WEAVE_CONFIGURATIONS_FILE

    # Remove last line if matches pattern sleep=*
    if [[ $(tail -n 1 "$WEAVE_CONFIGURATIONS_FILE") == sleep=* ]]; then
        # Remove the last line
        sed -i '$d' "$WEAVE_CONFIGURATIONS_FILE"
    fi
}