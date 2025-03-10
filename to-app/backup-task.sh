#!/bin/bash

# Exit immediately if a command fails
set -e

# Set and source environment variables using environment $1 (default: "dev")
if [ -f "./helpers/set-environment.sh" ]; then
    echo -e "\e[33mSetting environment...\e[0m"
    source ./helpers/set-environment.sh $1
fi

# Install required packages
if [ -f "./helpers/install-required.sh" ]; then
    echo -e "\e[33mInstalling required packages...\e[0m"
    ./helpers/install-required.sh
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

# Foreach service backup task
# add outptut to archive