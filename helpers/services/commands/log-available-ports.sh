#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script is used to log available ports for a weave service.

# Source utilities helpers
if [ -f "./weave-service/helpers/utils.sh" ]; then
    source ./weave-service/helpers/utils.sh
else
    echo -e "\e[31m$SERVICE_NAME: Cannot find 'utils' helper file. Exiting...\e[0m"
    exit 1
fi

# Source service's environment variables
if [ -f ".env" ]; then
    source .env
else
    echo -e "\e[31m$SERVICE_NAME: Cannot find '.env' helpers file. Exiting...\e[0m"
    exit 1
fi

env_name="$1"

echo -e "\e[33m$SERVICE_NAME: Trying to log available ports in environment '$env_name'...\e[0m"

# Iterate over all environment variables
for env_var in $(compgen -v); do

    if [[ "$env_var" =~ PORT ]]; then
        # Get the value of the port variable
        env_var_value=${!env_var}

        # Check if the value is a number
        if is_number "$env_var_value"; then

            if [[ "$env_var" == *"PORT"* && "$env_var" != *_PORT && "$env_var" != "PORT_"* ]]; then
                # If the variable contains just "PORT"
                echo -e "\e[32m$SERVICE_NAME: http://localhost:$env_var_value\e[0m"
            elif [[ "$env_var" == *_PORT || "$env_var" == "PORT_"* ]]; then
                # If the variable contains "_PORT" or "PORT_"
                subservice_name="${env_var//_PORT/}"
                subservice_name="${subservice_name//PORT_/}"
                echo -e "\e[32m$SERVICE_NAME:$subservice_name:http://localhost:$env_var_value\e[0m"
            fi
        fi
    fi
done