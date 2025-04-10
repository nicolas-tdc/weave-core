#!/bin/bash

# Exit immediately if a command fails
set -e

# This script is used to manage a weave service's backup task.

env_name="$1"

echo -e "\e[33m$SERVICE_NAME: Trying to start in environment '$env_name'...\e[0m"

backup_temp_dir=$2
# Copy files to be backed-up into $backup_temp_dir

echo -e "\e[32m$SERVICE_NAME: No backup task.\e[0m"