#!/bin/bash

# Exit immediately if a command fails
set -e

# Source services helpers
if [ -f "./weave/helpers/services.sh" ]; then
    source ./weave/helpers/services.sh
else
    echo -e "\e[31mCannot find 'services' file! Exiting...\e[0m"
    exit 1
fi

echo -e "\e[33mTrying to backup application '$APP_NAME'...\e[0m"

# Backup directory path input
echo -e "Enter backup directory path (default: './backups'): \c"
read backup_directory
backup_directory=${backup_directory:-"./backups"}

# Create backup directory
echo -e "\e[33mCreating backup directory...\e[0m"
mkdir -p $backup_directory

# Set backup variables
timestamp=$(date +"%Y%m%d-%H%M%S")
backup_name="backup-$timestamp"

backup_temp_dir=$(mktemp -d)

if [ -z "$1" ]; then
    echo -e "\e[33mTrying to backup-task application '$APP_NAME'...\e[0m"
    execute_command_on_all_services $SERVICES_DIRECTORY "backup-task" $backup_temp_dir
else
    service_name=$1
    echo -e "\e[33mTrying to backup-task service '$service_name'...\e[0m"
    execute_command_on_specific_service $SERVICES_DIRECTORY "backup-task" $service_name $backup_temp_dir
fi

tar -czvf $backup_directory/$backup_name.tar.gz -C "$backup_temp_dir" .
rm -rf "$backup_temp_dir"

echo -e "\e[32mApplication '$APP_NAME' updated.\e[0m"
