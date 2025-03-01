#!/bin/bash

# Exit immediately if a command fails
set -e

# Get environment variables
source .env

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
