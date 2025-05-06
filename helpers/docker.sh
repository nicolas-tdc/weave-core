#!/bin/bash

# Exit immediately if a command fails
set -e

# This script contains Docker related helper functions.

# Function: format_docker_compose
# Purpose: Formats a Docker Compose file by ensuring that each service has a unique container name and is connected to the specified network.
# Arguments:
#   1. service_name: The name of the service to be formatted.
#   2. compose_file: The path to the Docker Compose file to be formatted.
# Usage: format_docker_compose <service_name> <compose_file>
format_docker_compose() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "\e[31mformat_docker_compose() - Error: Two arguments are required.\e[0m"
        echo -e "\e[31musage: format_docker_compose <service_name> <compose_file>\e[0m"
        echo -e "\e[31mexample: format_docker_compose \"api\" \"docker-compose.yml\"\e[0m"
        exit 1
    fi

    local service_name=$1
    local compose_file=$2

    local app_env_file_path="../../.env"
    if ! grep -q "$app_env_file_path" "$compose_file"; then
        sed -i '/env_file:/a\ \ \ \ \ \ - '"$app_env_file_path" "$compose_file"
    fi

    awk -v container_name="$service_name" '
    BEGIN {
        inside_services = 0;
        inside_service_block = 0;
        inside_volumes = 0;
        inside_service_volumes = 0;
    }

    /^services:/ {
        inside_services = 1;
        print;
        next;
    }

    /^volumes:/ {
        inside_services = 0;
        inside_volumes = 1;
        print;
        next;
    }

    inside_volumes {
        if (/^[[:space:]]{2}([a-zA-Z0-9_-]+):$/) {
            gsub(/^[[:space:]]+/, "", $0)
            gsub(/:$/, "", $0)
            print "  " container_name "_" $0 ":"
        } else {
            print
        }
        next;
    }

    /^[[:space:]]{2}[a-zA-Z0-9_-]+:$/ {
        if (inside_services) {
            print "  " container_name ":"
            inside_service_block = 1;
            next;
        } else {
            print;
            next;
        }
    }

    inside_service_block && /^[[:space:]]{4}volumes:/ {
        inside_service_volumes = 1;
        print;
        next;
    }

    inside_service_volumes && /^[[:space:]]{6}-[[:space:]]*[^:]+:[^:]+/ {
        match($0, /^([[:space:]]*)- ([^:]+):(.+)$/, groups);
        vol_src = groups[2];
        vol_dest = groups[3];
        if (vol_src ~ /^[.~/]/) {
            print;
        } else {
            print groups[1] "- " container_name "_" vol_src ":" vol_dest;
        }
        next;
    }

    inside_service_volumes && !/^[[:space:]]{6}-/ {
        inside_service_volumes = 0;
    }

    { print }
    ' "$compose_file" > tmpfile && mv tmpfile "$compose_file"
}

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
