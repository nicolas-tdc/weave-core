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
        echo -e "\e[33mDo you want to add a weave service ? (yes/no): \c\e[0m"
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
        echo -e "\e[33mPlease select a service to add to your app:\e[0m"
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
            echo -e "Enter your service's name (default: '$available_service_name'): \c"
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
        for env in "dist" "prod" "staging" "dev"; do
            compose_file="$services_directory/$service_name/docker-compose.yml.$env"
            if [ -f "$compose_file" ]; then
                echo -e "\e[33m$$service_name: Formatting docker-compose.yml.$env file...\e[0m"
                format_docker_compose $APP_NAME $service_name $compose_file
            fi
        done

        # Weave default files
        if [ -d "./weave/default-service" ] && [ -d "$services_directory/$service_name" ]; then
            # Copy default service files to service's directory
            sudo cp -r ./weave/default-service/* "$services_directory/$service_name"
            sudo chmod -R 755 "$services_directory/$service_name"
        fi

        echo -e "\e[32mService $service_name added successfully.\e[0m"
    done
}

configure_external_services() {
    if [ -z "$1" ]; then
        echo -e "\e[31mconfigure_services() - Error: First argument is required.\e[0m"
        echo -e "\e[31musage: configure_services <services_directory>\e[0m"
        exit 1
    fi

    services_directory=$1
    git_shh_regex="^git@[a-zA-Z0-9.-]+:[^/]+/.+\.git$"

    # Add services
    while true; do # Keep or stop adding services
        echo -e "\e[33mDo you want to add an external service ? (yes/no): \c\e[0m"
        read add_service
        
        if [ "$add_service" == "no" ]; then
            break;
        elif ! [ "$add_service" == "yes" ]; then
            echo -e "\e[31mInvalid input.\e[0m"
            continue;
        fi

        # Service repository ssh address input
        while true; do
            echo -e "Enter your service's repository SSH address or 'done' to end services configuration: \c"
            read service_repository

            # Check for 'done' to exit the loop
            if [ "$service_repository" == "done" ]; then
                break 2  # Exit both loops if "done" is entered
            fi

            # Check for valid repository input
            if [[ "$service_repository" =~ $git_shh_regex ]]; then
                break  # Break the inner loop if valid input is provided
            else
                echo -e "\e[31mInvalid service repository input.\e[0m"
            fi
        done

        # End services configuration
        if [ "$service_repository" == "done" ]; then
            break;
        fi

        # Service name
        repository_name=$(basename "$service_repository" .git)
        # Service name input
        while true; do
            echo -e "Enter your service's name (default: '$repository_name'): \c"
            read service_name
            service_name=${service_name:-"$repository_name"}

            # Check if service directory already exists
            if ! [ -d "./$services_directory/$service_name" ]; then
                break;
            fi

            echo -e "\e[31mService name '$service_name' already used.\e[0m"
            continue;
        done

        if [ -f "./default-app/weave/helpers/git.sh" ]; then
            source ./default-app/weave/helpers/git.sh
            select_remote_branch "$service_repository"

            # Clone repository
            echo -e "\e[33mCloning repository...\e[0m"
            git clone --single-branch --branch "$SELECTED_BRANCH" "$service_repository" "$services_directory/$service_name"

            # Remove git remote
            rm -rf "$services_directory/$service_name/.git"

            # Weave default files
            if [ -d "./weave/default-service" ] && [ -d "$services_directory/$service_name" ]; then
                # Copy default service files to service directory
                sudo cp -r ./weave/default-service/* "$services_directory/$service_name"
                sudo chmod -R 755 "$services_directory/$service_name"
            fi

            echo -e "\e[32mService $service_name added successfully.\e[0m"
        fi
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
        elif [ -d "$service_path" ] && [ -f "${service_path}weave/helpers/$script_name" ]; then
            cd "$service_path"
            "weave/helpers/$script_name"
            cd - > /dev/null 2>&1
        fi
    done
}