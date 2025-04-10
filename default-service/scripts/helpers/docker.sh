#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script provides docker related functions for a weave service.

# Function: check_docker
# Purpose: Check if docker packages and necessary files are found
# Arguments: None
# Returns: 0 if successful, 1 if docker-compose.yml is not found
# Usage: check_docker
check_docker() {
    # Check if the docker-compose file exists
    if [[ ! -f "docker-compose.yml" ]]; then
        echo -e "\e[31mNo docker-compose.yml file found in service...\e[0m"
        exit 1
    fi

    # Required packages installation
    install_packages \
        docker \
        docker-compose
}

# Function: find_networks
# Purpose: Find networks defined in the docker-compose file
# Arguments: $1 - Optional path to the docker-compose file
# Returns: List of networks
# Usage: find_networks [docker-compose-file]
find_networks() {
    if [ -z "$1" ]; then
        compose_file="docker-compose.yml"
    else
        compose_file=$1
    fi

    awk '/networks:/ {getline; print $1}' "$compose_file" | sed 's/://g' | sort -u
}

# Function: create_networks
# Purpose: Create networks defined in the docker-compose file
# Arguments: $1 - Optional path to the docker-compose file
# Returns: None
# Usage: create_networks [docker-compose-file]
create_networks() {
    networks=$(find_networks "$1")
    
    # Loop through networks and create each one
    for net in $networks; do
        if [ -n "$net" ] && [ "$net" != "-" ]; then
            echo -e "\e[33mTrying to create network: $net\e[0m"
            docker network create "$net" 2>/dev/null \
                || echo -e "\e[33mNetwork $net already exists.\e[33m"
        fi
    done
}

# Function: remove_networks
# Purpose: Remove networks defined in the docker-compose file
# Arguments: $1 - Optional path to the docker-compose file
# Returns: None
# Usage: remove_networks [docker-compose-file]
remove_networks() {
    networks=$(find_networks $1)

    for net in $networks; do
        echo "Removing network: $net"
        docker network rm "$net" 2>/dev/null \
            || echo "Network $net does not exist."
    done
}
