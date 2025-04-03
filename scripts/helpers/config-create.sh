#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script provides functions to create and configure a new Weave application directory.

# Function: configure_name
# Purpose: Prompt user for application name and set it to a default value if not provided
# Arguments:
#   None
# Returns:
#   None
# Usage: configure_name
configure_name() {
    # Application name
    local default="app"
    # Application name input
    echo -e "\e[94mEnter application name (default: '$default'):\e[0m"
    read "APP_NAME"
    APP_NAME=${APP_NAME:-"$default"}

    export APP_NAME
}

# Function: configure_path
# Purpose: Prompt user for application directory path and set it to a default value if not provided
# Arguments:
#   None
# Returns:
#   None
# Usage: configure_path
configure_path() {
    # Application directory path
    while true; do
        # Application directory path input
        echo -e "\e[94mEnter the path where the application will be installed (default: '..'):\e[0m"
        read "APP_PARENT_PATH"
        APP_PARENT_PATH=${APP_PARENT_PATH:-".."}

        # Check for valid path input
        if ! [ -d "$APP_PARENT_PATH" ]; then
            echo -e "\e[31mInvalid path. Please choose a valid path.\e[0m"
            continue;
        fi

        # Expand tilde (~) to full home directory path
        APP_PARENT_PATH=$(eval echo "$APP_PARENT_PATH")

        export APP_PARENT_PATH="${APP_PARENT_PATH%/}"
        break;
    done
}

# Function: create_application_directory
# Purpose: Create the application directory if it doesn't exist
# Arguments:
#   $1: Application path
# Returns:
#   None
# Usage: create_application_directory <application_path>
create_application_directory() {
    if [ -z "$1" ]; then
        echo -e "\e[31mcreate_application_directory: Application path not set. Exiting...\e[0m"
        echo -e "\e[33mUsage: create_application_directory <application_path>\e[0m"
        exit 1
    fi
    local application_path="$1"

    # Check if application directory already exists
    if ! [ -d "$application_path" ]; then
        # Create application directory
        mkdir "$application_path"
    else
        # Prompt user to overwrite existing directory
        while true; do
            echo -e "\e[31mDirectory already exists:\e[0m"
            echo "$application_path"
            echo -e "\e[94mDo you want to overwrite it or exit? (ow/exit): \c\e[0m"
            read overwrite
            if [ "$overwrite" == "ow" ]; then
                sudo rm -rf "$application_path"
                mkdir "$application_path"
                break;
            elif [ "$overwrite" == "exit" ]; then
                echo -e "\e[31mExiting application initialization...\e[0m"
                exit 1
            else
                echo -e "\e[31mInvalid input.\e[0m"
            fi
        done
    fi
}

# Function: create_services_directory
# Purpose: Create the services directory within the application directory
# Arguments:
#   $1: Application path
# Returns:
#   None
# Usage: create_services_directory <application_path>
create_services_directory() {
    if [ -z "$1" ]; then
        echo -e "\e[31mcreate_services_directory: Application path not set. Exiting...\e[0m"
        echo -e "\e[33mUsage: create_services_directory <application_path>\e[0m"
        exit 1
    fi
    local application_path="$1"

    local default="services"
    echo -e "\e[94mEnter your services' directory name (default: '$default'):\e[0m"
    # Input services directory
    read "SERVICES_DIRECTORY"
    SERVICES_DIRECTORY=${SERVICES_DIRECTORY:-"$default"}
       
    # Create services directory
    mkdir -p "$application_path/$SERVICES_DIRECTORY"

    export SERVICES_DIRECTORY
}

# Function: configure_environment_file
# Purpose: Create and configure the environment file for the application
# Arguments:
#   $1: Application path
#   $2: Application name
#   $3: Services directory
# Returns:
#   None
# Usage: configure_environment_file <application_path> <application_name> <services_directory>
configure_environment_file() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3"]; then
        echo -e "\e[31mcreate_services_directory: Arguments missing. Exiting...\e[0m"
        echo -e "\e[33mUsage: create_services_directory <application_path> <application_name> <services_directory>\e[0m"
        exit 1
    fi
    local application_path="$1"
    local application_name="$2"
    local services_directory="$3"

    # Initial environment dist file
    local app_env_file="$application_path/.env.dist"

    # Initial application environment variables
    echo "# $application_name global env variables" > $app_env_file
    echo "SERVICES_DIRECTORY=\"$services_directory\"" >> $app_env_file
}