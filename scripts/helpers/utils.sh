#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function: check_default_files
# Purpose: Check application and services default files directories exist
# Arguments:
#   None
# Returns:
#   0 if all directories exist
#   1 if any directory does not exist
# Usage: check_default_files
check_default_files() {
    if ! [ -d "./default-app" ]; then
        echo -e "\e[31mCannot find default application folder! Exiting...\e[0m"
        exit 1
    fi

    if ! [ -d "./default-service" ]; then
        echo -e "\e[31mCannot find default service folder! Exiting...\e[0m"
        exit 1
    fi

    if ! [ -d "./available-services" ]; then
        echo -e "\e[31mCannot find available services folder! Exiting...\e[0m"
        exit 1
    fi
}

# Function: copy_default_files
# Purpose: Copy default application and service files to the specified application path
# Arguments:
#   $1: Application path
# Returns:
#   None
# Usage: copy_default_files <application_path>
copy_default_files() {
    if [ -z "$1" ]; then
        echo -e "\e[31mcopy_default_files: Application path not set. Exiting...\e[0m"
        echo -e "\e[33mUsage: copy_default_files <application_path>\e[0m"
        exit 1
    fi
    local application_path="$1"

    if [ -d "$application_path" ]; then
        sudo cp -r ./default-app/* "$application_path"
        sudo cp -r ./default-service "$application_path/weave"
        sudo cp -r ./available-services "$application_path/weave"
    fi
}