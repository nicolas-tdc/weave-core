#!/bin/bash

# Exit immediately if a command fails
set -e

# This script contains Docker related helper functions.

# Function: format_docker_compose
# Purpose: Formats a Docker Compose file by ensuring that each service has a unique container name and is connected to the specified network.
# Arguments:
#   1. service_name: The name of the service to be formatted.
#   2. compose_file: The path to the Docker Compose file to be formatted.
#   3. network_name: The name of the network to which the service should be connected.
# Usage: format_docker_compose <service_name> <compose_file> <network_name>
format_docker_compose() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo -e "\e[31mformat_docker_compose() - Error: Three arguments are required.\e[0m"
        echo -e "\e[31musage: format_docker_compose <service_name> <compose_file> <network_name>\e[0m"
        exit 1
    fi

    local service_name=$1
    local compose_file=$2
    local network_name=$3

    local app_env_file_path="../../.env"
    if ! grep -q "$app_env_file_path" "$compose_file"; then
        sed -i '/env_file:/a\ \ \ \ \ \ - '"$app_env_file_path" "$compose_file"
    fi

    awk -v container_name="$service_name" -v net="$network_name" '
    BEGIN {
        inside_service=0; inside_volumes=0; inside_networks=0; inside_service_volumes=0;
        service_name=""; added_container_name=0; added_networks=0;
    }

    /^services:/ { print; next }
    /^volumes:/ { print; inside_volumes=1; inside_service=0; next }
    /^networks:/ { print; inside_networks=1; inside_service=0; next }

    inside_volumes || inside_networks {
        if (inside_volumes && /^[[:space:]]{2}([a-zA-Z0-9_-]+):$/) {
            gsub(/^[[:space:]]+/, "", $0)
            gsub(/:$/, "", $0)
            print "  " container_name "_" $0 ":"
        } else {
            print
        }
        next
    }

    /^[[:space:]]{2}([a-zA-Z0-9_-]+):$/ {
        service_name = substr($0, match($0, /^[[:space:]]{2}([a-zA-Z0-9_-]+):/), RLENGTH)
        gsub(/^[[:space:]]+/, "", service_name)
        gsub(/:$/, "", service_name)
        modified_service_name = container_name "_" service_name
        print "  " modified_service_name ":"
        if (added_container_name == 0) {
            print "    container_name: " modified_service_name
            added_container_name = 1
        }
        if (added_networks == 0) {
            print "    networks:"
            print "      - " net
            added_networks = 1
        }
        inside_service=1
        next
    }

    inside_service && /^[[:space:]]{4}container_name:/ { next }

    inside_service && /^[[:space:]]{4}volumes:/ {
        inside_service_volumes=1
        print
        next
    }

    inside_service_volumes && /^[[:space:]]{6}-[[:space:]]*[^:]+:[^:]+/ {
        match($0, /^([[:space:]]*)- ([^:]+):(.+)$/, groups)
        vol_src = groups[2]
        vol_dest = groups[3]
        if (vol_src ~ /^[.~/]/) {
            print
        } else {
            print groups[1] "- " container_name "_" vol_src ":" vol_dest
        }
        next
    }

    inside_service_volumes && !/^[[:space:]]{6}-/ { inside_service_volumes=0 }

    { print }

    END {
        if (inside_service && added_container_name == 0)
            print "    container_name: " modified_service_name "\n    networks:\n      - " net
    }
    ' "$compose_file" > tmpfile && mv tmpfile "$compose_file"

    # Add network section if missing
    if ! grep -q "^networks:" "$compose_file"; then
        echo -e "\nnetworks:\n  $network_name:\n    external: true" >> "$compose_file"
    elif ! grep -q "$network_name" "$compose_file"; then
        echo -e "  $network_name:\n    external: true" >> "$compose_file"
    fi
}

