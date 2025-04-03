#!/bin/bash

# Exit immediately if a command fails
set -e

configure_weave_services() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "\e[31mconfigure_weave_services() - Error: First and second argument are required.\e[0m"
        echo -e "\e[31musage: configure_weave_services <services_directory> <weave_services_directory>\e[0m"
        exit 1
    fi

    services_directory=$1
    weave_services_directory=$2

    # Add services
    while true; do
        # Keep or stop adding services
        echo -e "\e[94mDo you want to add a weave service ? (yes/no): \c\e[0m"
        read add_service
        
        if [ "$add_service" == "no" ]; then
            break;
        elif ! [ "$add_service" == "yes" ]; then
            echo -e "\e[31mInvalid input.\e[0m"
            continue;
        fi

        # Get available services list
        available_services=()
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
                available_service_name=$(basename "$selected_service")

                break;
            else
                echo "\e[31mInvalid selection, please try again.\e[0m"
            fi
        done

        # Service name
        while true; do
            echo -e "\e[94mEnter your service's name (default: '$available_service_name'):\e[0m"
            read service_name
            service_name=${service_name:-"$available_service_name"}

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
        compose_file="$services_directory/$service_name/docker-compose.yml"
        if [ -f "$compose_file" ]; then
            echo -e "\e[33m$service_name: Formatting docker-compose.yml file...\e[0m"
            format_docker_compose $service_name $compose_file "${APP_NAME}_network"
        fi

        # Weave default files
        if [ -d "./default-service" ] && [ -d "$services_directory/$service_name" ]; then
            # Copy default service files to service's directory
            sudo cp -r ./default-service/* "$services_directory/$service_name"
            sudo chmod -R 755 "$services_directory/$service_name"
        fi

        echo -e "\e[32mService $service_name added successfully.\e[0m"
    done
}

execute_services_specific_script() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "\e[31mexecute_services_specific_script() - Error: First and second argument are required.\e[0m"
        echo -e "\e[31musage: execute_services_specific_script <services_directory> <script_name>\e[0m"
        exit 1
    fi

    services_directory=$1
    script_name=$2

    # Stop all services
    for service_path in $services_directory/*/; do
        # Check if it's a directory
        if [ -d "$service_path" ] && [ -f "${service_path}weave/scripts/$script_name" ]; then
            cd "$service_path"
            "weave/scripts/$script_name"
            cd - > /dev/null 2>&1
        fi
    done
}