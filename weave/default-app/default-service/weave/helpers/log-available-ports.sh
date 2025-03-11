#!/bin/bash

# Exit immediately if a command fails
set -e

SERVICE_NAME=$(basename "$PWD") > /dev/null 2>&1

echo -e "\e[32m-----Access $SERVICE_NAME-----\e[0m"

# Load environment variables from the .env file
if [ -f ".env" ]; then
    source .env
else
    echo -e "\e[31m$SERVICE_NAME: No .env file found for logging ports available!\e[0m"
    exit 1
fi

# Function to check if a string is a number
is_number() {
    [[ "$1" =~ ^[0-9]+$ ]] && return 0 || return 1
}

# Iterate over all environment variables
for ENV_VAR in $(compgen -v); do
    # Check if the variable name contains "PORT"
    if [[ "$ENV_VAR" =~ PORT ]]; then
        # Get the value of the variable
        ENV_VAR_VALUE=${!ENV_VAR}

        # Check if the value is a number
        if is_number "$ENV_VAR_VALUE"; then
            if [[ "$ENV_VAR" == *"PORT"* && "$ENV_VAR" != *_PORT && "$ENV_VAR" != "PORT_"* ]]; then
                # If the variable contains just "PORT"
                echo -e "\e[32m$SERVICE_NAME: http://localhost:$ENV_VAR_VALUE\e[0m"
            elif [[ "$ENV_VAR" == *_PORT || "$ENV_VAR" == "PORT_"* ]]; then
                # If the variable contains "_PORT" or "PORT_"
                SUBSERVICE_NAME="${ENV_VAR//_PORT/}"
                SUBSERVICE_NAME="${SUBSERVICE_NAME//PORT_/}"
                echo -e "\e[32m$SERVICE_NAME:$SUBSERVICE_NAME:http://localhost:$ENV_VAR_VALUE\e[0m"
            fi
        fi
    fi
done
