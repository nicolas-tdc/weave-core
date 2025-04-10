#!/bin/bash

# Exit immediately if a command fails
set -e

# This script is used to manage a weave service's backup task.

# Copy backup files to $backup_temp_dir
backup_temp_dir=$1

echo -e "\e[32m$SERVICE_NAME: No backup task.\e[0m"