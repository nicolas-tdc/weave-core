#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

set_service_environment() {
    export SERVICE_NAME=$(basename "$PWD") > /dev/null 2>&1

    # Set application environment if not set
    if [ -z "$APP_ENV" ]; then
        if ! [ -z "$1" ]; then
            export APP_ENV="$1"
        else
            # Default to dev environment
            export APP_ENV="dev"
        fi
    fi

    # Check if the service environment file exists
    if [[ ! -f ".env" && ! -f ".env.dist" && ! -f ".env.$APP_ENV" ]]; then
        echo -e "\e[31m$SERVICE_NAME: No compatible environment file found : .env|.env.dist|.env.$APP_ENV...\e[0m"
        exit 1
    fi

    # Check if the docker-compose file exists
    if [[ ! -f "docker-compose.yml" && ! -f "docker-compose.yml.dist" && ! -f "docker-compose.yml.$APP_ENV" ]]; then
        echo -e "\e[31m$SERVICE_NAME: No compatible docker-compose file found : docker-compose.yml|docker-compose.yml.dist|docker-compose.yml.$APP_ENV...\e[0m"
        exit 1
    fi

    # Copy relevant environment file
    if [ -f ".env.$APP_ENV" ]; then
        echo -e "\e[33$SERVICE_NAME: Copying $APP_ENV environment file...\e[0m"
        sudo cp ".env.$APP_ENV" .env
    elif [ -f ".env.dist" ]; then
        echo -e "\e[33m$SERVICE_NAME: Copying .env.dist environment file...\e[0m"
        sudo cp .env.dist .env
    else
        echo -e "\e[33m$SERVICE_NAME: Backing-up .env file...\e[0m"
        sudo cp .env .env.dist
    fi

    # Copy relevant docker-compose file
    if [ -f "docker-compose.yml.$APP_ENV" ]; then
        echo -e "\e[33m$SERVICE_NAME: Copying $APP_ENV docker compose file...\e[0m"
        sudo cp docker-compose.yml.$APP_ENV docker-compose.yml
    elif [ -f "docker-compose.yml.dist" ]; then
        echo -e "\e[33m$SERVICE_NAME: Copying dist docker compose file...\e[0m"
        sudo cp docker-compose.yml.dist docker-compose.yml
    else
        echo -e "\e[33m$SERVICE_NAME: Backing-up docker-compose.yml...\e[0m"
        sudo cp docker-compose.yml docker-compose.yml.dist
    fi

    echo -e "\e[32m$SERVICE_NAME: Docker-compose and environment file ready.\e[0m"
}

log_available_ports() {
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
}
