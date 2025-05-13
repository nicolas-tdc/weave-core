#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script contains git related helper functions.

# Function: merge_gitignore_file
# Purpose: Merges the .gitignore file of a service into the main .gitignore file.
# Arguments:
#   1. service_name: The name of the service to be merged.
#   2. service_path: The path to the service directory.
# Returns: None
# Usage: merge_gitignore_file <service_name> <service_path>
# Notes: This function will create a new .gitignore file if it doesn't exist and append the service-specific entries to it.
# It will also remove the service's .gitignore file after merging.
merge_gitignore_file() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "\e[31mmerge_gitignore_file() - Error: Two arguments are required.\e[0m"
        echo -e "\e[31musage: merge_gitignore_file <service_name> <service_path>\e[0m"
        exit 1
    fi
    local service_name=$1
    local service_path=$2

    # Set the input and output gitignore file paths
    local input_gitignore="$service_path/.gitignore"
    local output_gitignore=".gitignore"

    # Check if the gitignore files exist
    if [ -f "$input_gitignore" ]; then
        if [ ! -f "$output_gitignore" ]; then
            echo -e "# Application specifics\n.env\nweave.sh\n# Services specifics" > $output_gitignore
        fi

        # Append service name to output gitignore
        echo "# $service_name" >> "$output_gitignore"

        # Append input gitignore entries to output gitignore
        while IFS= read -r line; do
            [[ -z "$line" || "$line" =~ ^\s*# ]] && continue
            if [[ "$line" == /* ]]; then
                echo "$line" >> "$output_gitignore"
            else
                echo "${service_path}/$line" >> "$output_gitignore"
            fi
        done < "$input_gitignore"

        # Remove child .gitignore
        rm "$input_gitignore"
    fi
}

# Function: remove_service_from_gitignore
# Purpose: Removes the service-specific entries from the main .gitignore file.
# Arguments:
#   1. service_name: The name of the service to be removed.
# Returns: None
# Usage: remove_service_from_gitignore <service_name>
# Notes: This function will remove all lines containing the service name from the .gitignore file.
# It will also remove all empty lines following the service name.
remove_service_from_gitignore() {
    if [ -z "$1" ]; then
        echo -e "\e[31mremove_service_from_gitignore() - Error: First argument is required.\e[0m"
        echo -e "\e[31musage: remove_service_from_gitignore <service_name>\e[0m"
        exit 1
    fi
    local service_name=$1

    local output_gitignore=".gitignore"

    # Remove all empty lines following the service name
    sed -i "/$service_name/,/^$/d" "$output_gitignore"

    # Remove all lines containing the service name from the .gitignore file
    sed -i "/$service_name/d" "$output_gitignore"
}

# Function: update_git_submodules
# Purpose: Updates all git submodules to the latest version.
# Arguments: None
# Returns:
#   0: If all submodules were updated successfully.
#   1: If there was an error updating any submodule.
# Usage: update_git_submodules
update_git_submodules() {
    # Update the submodules
    git submodule update --init --recursive
    git submodule sync --recursive

    # Pull the latest changes from the main branch of each submodule
    git submodule foreach --recursive '
        echo "Updating submodule: $name"
        git fetch
        git checkout main 2>/dev/null || git checkout master 2>/dev/null || echo "No main/master branch for $name"
        git pull || echo "Failed to pull in $name"
    '
}
