#!/bin/bash

# Exit immediately if a command fails
set -e

if [ -f "./helpers/set-environment.sh" ]; then
    source ./helpers/set-environment.sh $1
fi

echo -e "\e[33mUpdating $SERVICE_NAME...\e[0m"

# Add update task here
echo -e "\e[33mNo update task for $SERVICE_NAME.\e[0m"