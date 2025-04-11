#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script contains git related helper functions.

# Function: merge_gitignore_files
# Purpose: Merges multiple .gitignore files from child directories into a single parent .gitignore file.
# Arguments:
#   1. services_directory: The directory containing child directories with .gitignore files.
#   2. output_gitignore: The path to the output .gitignore file.
# Usage: merge_gitignore_files <services_directory> <output_gitignore>
merge_gitignore_files() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "\e[31mmerge_gitignore_files() - Error: First and second argument are required.\e[0m"
        echo -e "\e[31musage: merge_gitignore_files <services_directory> <output_gitignore>\e[0m"
        exit 1
    fi

    local services_directory=$1
    local output_gitignore=$2

    if [ ! -f "$output_gitignore" ]; then
        touch $output_gitignore
    else
        echo "" >> "$output_gitignore"
    fi

    # Collect child .gitignore entries and append to parent .gitignore
    {
        for service in $services_directory/*/; do
            local input_gitignore="${service}.gitignore"
            
            if [ -f "$input_gitignore" ]; then
                # Append service name to output gitignore
                local service_name="${service#./services/}"
                echo "" >> "$output_gitignore"
                echo "# $service" >> "$output_gitignore"
                echo "" >> "$output_gitignore"

                # Append input gitignore entries to output gitignore
                while IFS= read -r line; do
                    [[ -z "$line" || "$line" =~ ^\s*# ]] && continue
                    if [[ "$line" == /* ]]; then
                        echo "$line" >> "$output_gitignore"
                    else
                        echo "${service_name}$line" >> "$output_gitignore"
                    fi
                done < "$input_gitignore"

                # Remove child .gitignore
                rm "$input_gitignore"
            fi
        done
    }
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
