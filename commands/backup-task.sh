#!/bin/bash

# Exit immediately if a command fails
set -e

# This script is used to backup the application and its services.

# Source services helpers
if [ -f "./weave-core/helpers/services.sh" ]; then
    source ./weave-core/helpers/services.sh
else
    echo -e "\e[31mCannot find 'services' helpers file. Exiting...\e[0m"
    exit 1
fi

echo -e "\e[33mTrying to backup application '$APP_NAME'...\e[0m"

# Create backup temp directory
backup_temp_dir=$(mktemp -d)

# Extract service name from command line arguments
service_name=$1
shift

if [ -z "$service_name" ]; then
    # Execute the backup command on all services
    echo -e "\e[33mTrying to backup application '$APP_NAME'...\e[0m"
    backup_name="${APP_NAME}_$(date +"%Y%m%d-%H%M%S")"

    execute_command_on_all_services \
        $SERVICES_DIRECTORY \
        "backup-task" \
        $backup_temp_dir \
        "$@"

    echo -e "\e[32mFinished backing up application '$APP_NAME'.\e[0m"
else
    # Execute the backup command on a specific service
    echo -e "\e[33mTrying to backup service '$service_name'...\e[0m"
    backup_name="${APP_NAME}_${service_name}_$(date +"%Y%m%d-%H%M%S")"
 
    execute_command_on_specific_service \
        $SERVICES_DIRECTORY \
        "backup-task" \
        $service_name \
        $backup_temp_dir \
        "$@"
 
    echo -e "\e[32mFinished backing up service '$service_name'.\e[0m"
fi

# Create a tarball of the backup
echo -e "\e[33mCreating archive and removing temp directory...\e[0m"
tar -czvf $BACKUP_DIRECTORY/$backup_name.tar.gz -C "$backup_temp_dir" . > /dev/null 2>&1
rm -rf "$backup_temp_dir"

echo -e "\e[32mCreated backup '$backup_name' in '$BACKUP_DIRECTORY' successfully.\e[0m"
