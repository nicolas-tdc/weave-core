#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

if [ -z "$1" ]; then
    service_name=$(basename "$PWD") > /dev/null 2>&1
else
    service_name=$1
fi

echo -e "\e[32m-----Access $service_name-----\e[0m"

# Load environment variables from the .env file
if [ -f ".env" ]; then
    source .env
else
    echo -e "\e[31m$service_name: No .env file found for logging ports available!\e[0m"
    exit 1
fi

# Function to check if a string is a number
is_number() {
    [[ "$1" =~ ^[0-9]+$ ]] && return 0 || return 1
}

# Iterate over all environment variables
for env_var in $(compgen -v); do
    # Check if the variable name contains "PORT"
    if [[ "$env_var" =~ PORT ]]; then
        # Get the value of the variable
        env_var_value=${!env_var}

        # Check if the value is a number
        if is_number "$env_var_value"; then
            if [[ "$env_var" == *"PORT"* && "$env_var" != *_PORT && "$env_var" != "PORT_"* ]]; then
                # If the variable contains just "PORT"
                echo -e "\e[32m$service_name: http://localhost:$env_var_value\e[0m"
            elif [[ "$env_var" == *_PORT || "$env_var" == "PORT_"* ]]; then
                # If the variable contains "_PORT" or "PORT_"
                subservice_name="${env_var//_PORT/}"
                subservice_name="${subservice_name//PORT_/}"
                echo -e "\e[32m$service_name:$subservice_name:http://localhost:$env_var_value\e[0m"
            fi
        fi
    fi
done