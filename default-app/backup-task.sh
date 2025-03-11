#!/bin/bash

# Exit immediately if a command fails
set -e

# Set and source environment variables using environment $1 (default: "dev")
if [ -f "./weave/helpers/set-environment.sh" ]; then
    echo -e "\e[33mSetting environment...\e[0m"
    source ./weave/helpers/set-environment.sh $1
fi

# Install required packages
if [ -f "./weave/helpers/install-required.sh" ]; then
    echo -e "\e[33mInstalling required packages...\e[0m"
    ./weave/helpers/install-required.sh
fi

# Backup directory path input
echo -e "Enter backup directory path (default: './backups'): \c"
read BACKUP_DIR
BACKUP_DIR=${BACKUP_DIR:-"./backups"}
export BACKUP_DIR

# Create backup directory
echo -e "\e[33mCreating backup directory...\e[0m"
mkdir -p $BACKUP_DIR

# Set backup variables
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
export BACKUP_FILENAME="backup-$TIMESTAMP.tar.gz"

# Execute service specific scripts
if [ -f "./weave/helpers/services/execute-specific.sh" ]; then
    ./weave/helpers/services/execute-specific.sh $(basename "$0")
fi
