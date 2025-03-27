#!/bin/bash

# Exit immediately if a command fails
set -e

format_docker_compose() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo -e "\e[31mformat_docker_compose() - Error: Three arguments are required.\e[0m"
        echo -e "\e[31musage: format_docker_compose <application_name> <service_name> <compose_file>\e[0m"
        exit 1
    fi

    app_name=$1
    service_name=$2
    compose_file=$3

    network_name="${app_name}_network"
    app_env_file_path="../../.env"

    # Ensure the application env file is added if not present
    if ! grep -q "$app_env_file_path" "$compose_file"; then
        sed -i '/env_file:/a\ \ \ \ \ \ - '"$app_env_file_path" "$compose_file"
    fi

    # Process the docker-compose file
    awk -v new_prefix="$service_name" -v net="$network_name" '
    BEGIN { inside_service=0; has_container_name=0; has_networks=0 }

    /^services:/ { print; next }

    /^[[:space:]]{2}([a-zA-Z0-9_-]+):$/ {
        # Capture original service name
        orig_service_name = substr($0, match($0, /^[[:space:]]{2}([a-zA-Z0-9_-]+):/), RLENGTH)
        gsub(/^[[:space:]]+/, "", orig_service_name)
        gsub(/:$/, "", orig_service_name)

        # Create new service name
        modified_service_name = new_prefix "_" orig_service_name
        print "  " modified_service_name ":"
        
        inside_service = 1
        has_container_name = 0
        has_networks = 0
        next
    }

    inside_service && /^[[:space:]]{4}container_name:/ { has_container_name=1; next }
    inside_service && /^[[:space:]]{4}networks:/ { has_networks=1; next }

    { print }

    # Ensure container_name is inserted immediately after the service starts
    inside_service && !has_container_name {
        print "    container_name: " modified_service_name
        has_container_name = 1
    }

    # Ensure networks is inserted
    inside_service && !has_networks {
        print "    networks:\n      - " net
        has_networks = 1
    }
    ' "$compose_file" > tmpfile && mv tmpfile "$compose_file"

    # Ensure the networks section exists at the bottom
    if ! grep -q "^networks:" "$compose_file"; then
        echo -e "\nnetworks:\n  $network_name:\n    external: true" >> "$compose_file"
    elif ! grep -q "$network_name" "$compose_file"; then
        echo -e "  $network_name:\n    external: true" >> "$compose_file"
    fi
}
