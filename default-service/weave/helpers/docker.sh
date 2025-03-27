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

    grep -rohP '(?<=networks:\n\s{2})[^\s:]+' $compose_file | sort -u
}

# Function to create networks
create_networks() {
    networks=$(find_networks $1)
    echo -e "$networks"
    for net in $networks; do
        echo "Creating network: $net"
        docker network create "$net" 2>/dev/null || echo "Network $net already exists."
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
