#!/bin/bash

# Exit immediately if a command fails
set -e

validate_service_files() {
    if [ -z "$1" ]; then
        echo -e "\e[31mvalidate_service_files() - Error: First argument is required.\e[0m"
        echo -e "\e[31musage: validate_service_files <service_path>...>\e[0m"
        exit 1
    fi

    service_path=$1

    # Check for distant files
    echo -e "\e[33mSearching for .dist files...\e[0m"
    if [ -f "$service_path/.env.dist" ] && [ -f "$service_path/docker-compose.yml.dist"]; then
        return 0
    fi

    echo -e "\e[33mNo .dist files, searching for env specific files...\e[0m"
    files_invalid=0
    for env_name in "prod" "staging" "dev"; do
        if ! [ -f "$service_path/.env.$env_name" ]; then
            echo -e "\e[31mMissing env.$env_name"
            files_invalid=1
        fi
        if ! [ -f "$service_path/docker-compose.yml.$env_name" ]; then
            echo -e "\e[31mMissing docker-compose.yml.$env_name"
            files_invalid=1
        fi
    done
    
    return $files_invalid
}

configure_services() {
    if [ -z "$1" ]; then
        echo -e "\e[31mconfigure_services() - Error: First argument is required.\e[0m"
        echo -e "\e[31musage: configure_services <services_directory>\e[0m"
        exit 1
    fi

    services_directory=$1
    git_shh_regex="^git@[a-zA-Z0-9.-]+:[^/]+/.+\.git$"

    # Add services
    while true; do
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

            # Validate cloned service's files
            validate_service_files "$services_directory/$service_name"
            if [ $? -eq 1 ]; then
                while true; do
                    echo -e "\e[31mService missing environment and docker-compose files.\e[0m"
                    echo -e "\e[33mDo you want to add it anyway? (yes/no): \c\e[0m"
                    read ignore_missing
                    
                    abort_service=false
                    if [ "$ignore_missing" == "yes" ]; then
                        break;
                    elif [ "$ignore_missing" == "no" ]; then
                        abort_service=true
                        break;
                    else
                        echo -e "\e[31mInvalid input.\e[0m"
                    fi
                done

                if [ $abort_service = true ]; then
                    rm -rf "$services_directory/$service_name"
                    continue;
                fi
            fi

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