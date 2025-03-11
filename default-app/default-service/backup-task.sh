#!/bin/bash

# Exit immediately if a command fails
set -e

SERVICE_NAME=$(basename "$PWD") > /dev/null 2>&1

echo -e "\e[33mBacking-up $SERVICE_NAME...\e[0m"

# Add backup task here
echo -e "\e[33mNo backup task for $SERVICE_NAME.\e[0m"