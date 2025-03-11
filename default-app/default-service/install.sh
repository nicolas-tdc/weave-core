#!/bin/bash

# Exit immediately if a command fails
set -e

SERVICE_NAME=$(basename "$PWD") > /dev/null 2>&1

echo -e "\e[33mInstalling $SERVICE_NAME...\e[0m"

# Add install task here
echo -e "\e[33mNo install task for $SERVICE_NAME.\e[0m"