#!/bin/bash

# Exit immediately if a command fails
set -e

# Source utilities helpers
if [ -f "./weave/helpers/utils.sh" ]; then
    source ./weave/helpers/utils.sh
else
    echo -e "\e[31mCannot find 'utils' file! Exiting...\e[0m"
    exit 1
fi

# Source services helpers
if [ -f "./weave/helpers/services.sh" ]; then
    source ./weave/helpers/services.sh
else
    echo -e "\e[31mCannot find 'services' file! Exiting...\e[0m"
    exit 1
fi

set_application_environment $1

echo -e "\e[33mTrying to backup application '$APP_NAME' in '$APP_ENV' environment...\e[0m"

# Backup directory path input
echo -e "Enter backup directory path (default: './backups'): \c"
read BACKUP_DIR
export BACKUP_DIR=${BACKUP_DIR:-"./backups"}

# Create backup directory
echo -e "\e[33mCreating backup directory...\e[0m"
mkdir -p $BACKUP_DIR

# Set backup variables
timestamp=$(date +"%Y%m%d-%H%M%S")
export BACKUP_FILENAME="backup-$timestamp.tar.gz"

execute_services_specific_script $SERVICES_DIRECTORY "backup-task.sh"

echo -e "\e[32mApplication '$APP_NAME' updated in '$APP_ENV' environment.\e[0m"
