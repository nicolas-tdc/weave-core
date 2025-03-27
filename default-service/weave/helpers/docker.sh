#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to find application's or service's networks
find_networks() {
    if [ -z "$1" ]; then
        compose_file="docker-compose.yml"
    else
        compose_file=$1
    fi

    awk '/networks:/ {getline; print $1}' "$compose_file" | sed 's/://g' | sort -u
}

# Function to create networks
create_networks() {
    networks=$(find_networks "$1")
    
    # Loop through networks and create each one
    for net in $networks; do
        if [ -n "$net" ] && [ "$net" != "-" ]; then
            echo -e "\e[33mTrying to create network: $net\e[0m"
            docker network create "$net" 2>/dev/null || echo -e "\e[33mNetwork $net already exists.\e[33m"
        fi
    done
}

# Function to remove networks
remove_networks() {
    networks=$(find_networks $1)

    for net in $networks; do
        echo "Removing network: $net"
        docker network rm "$net" 2>/dev/null || echo "Network $net does not exist."
    done
}
