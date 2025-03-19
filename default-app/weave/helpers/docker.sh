#!/bin/bash

# Exit immediately if a command fails
set -e

create_network() {
    if [ -z "$1" ]; then
        echo -e "\e[31mcreate_network() - Error: First argument is required.\e[0m"
        echo -e "\e[31musage: create_network <network_name>...>\e[0m"
        exit 1
    fi

    network_name=$1

    # Create app network if it doesn't exist
    docker network ls --filter name="$network_name" -q > /dev/null
    if [ $? -eq 0 ]; then
        echo -e "\e[33mCreating network '$network_name'...\e[0m"
        sudo docker network create "$network_name"
    fi
}

remove_network() {
    if [ -z "$1" ]; then
        echo -e "\e[31mremove_network() - Error: First argument is required.\e[0m"
        echo -e "\e[31musage: remove_network <network_name>...>\e[0m"
        exit 1
    fi

    network_name=$1

    # Remove app network if it exists
    docker network ls --filter name="$network_name" -q > /dev/null
    if ! [ $? -eq 0 ]; then
        docker network rm "$network_name"
        echo -e "\e[32mNetwork '$network_name' removed.\e[0m"
    fi
}