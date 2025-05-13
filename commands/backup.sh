#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

get_backups_directory

# Create a tarball of the backup
if [ "$SERVICE_NAME" == "" ]; then
    # Backup all services
    backup_name="${APP_NAME}_$(date +"%Y%m%d-%H%M%S")"
else
    # Backup specific service
    backup_name="${APP_NAME}_${SERVICE_NAME}_$(date +"%Y%m%d-%H%M%S")"
fi

backup_temp_dir=$(realpath "$(mktemp -d)")

# Backup services
# @todo: Execute service custom script in service root directory 'backup.sh'
# The app owner will be responsible for creating the backup script for each service
# Pass the backup directory as an argument to the script
echo -e "\e[33mWIP: Backing up services...\e[0m"]

# Create archive
echo -e "\e[33mCreating archive...\e[0m"
tar -czvf $BACKUPS_DIRECTORY/$backup_name.tar.gz -C "$backup_temp_dir" . # > /dev/null 2>&1

# Remove temporary backup directory
rm -rf "$backup_temp_dir"

echo -e "\e[32mCreated backup '$backup_name' in '$BACKUPS_DIRECTORY' successfully.\e[0m"