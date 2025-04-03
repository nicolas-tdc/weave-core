#!/bin/bash

# Exit immediately if a command fails
set -e

format_docker_compose() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo -e "\e[31mformat_docker_compose() - Error: Three arguments are required.\e[0m"
        echo -e "\e[31musage: format_docker_compose <service_name> <compose_file> <network_name>\e[0m"
        exit 1
    fi

    service_name=$1
    compose_file=$2
    network_name=$3

    # Ensure the application env file is added
    app_env_file_path="../../.env"
    if ! grep -q "$app_env_file_path" "$compose_file"; then
        sed -i '/env_file:/a\ \ \ \ \ \ - '"$app_env_file_path" "$compose_file"
    fi

    # Ensure each service has the network assigned and container_name is set
    awk -v container_name="$service_name" -v net="$network_name" '
    BEGIN { inside_service=0; inside_volumes=0; inside_networks=0; inside_service_volumes=0; service_name=""; added_container_name=0; added_networks=0 }

    /^services:/ { print; next }
    /^volumes:/ { print; inside_volumes=1; inside_service=0; next }
    /^networks:/ { print; inside_networks=1; inside_service=0; next }

    inside_volumes || inside_networks { 
        if (inside_volumes && /^[[:space:]]{2}([a-zA-Z0-9_-]+):$/) { 
            gsub(/^[[:space:]]+/, "", $0)
            gsub(/:$/, "", $0)
            print "  " container_name "_" $0 ":"  # Rename global volumes
        } else { 
            print 
        }
        next 
    }

    /^[[:space:]]{2}([a-zA-Z0-9_-]+):$/ {
        # Capture service name
        service_name = substr($0, match($0, /^[[:space:]]{2}([a-zA-Z0-9_-]+):/), RLENGTH)
        gsub(/^[[:space:]]+/, "", service_name)
        gsub(/:$/, "", service_name)

        # Modify service name and add container_name
        modified_service_name = container_name "_" service_name
        print "  " modified_service_name ":"
        
        # Ensure container_name and networks sections are added only once
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

    inside_service && /^[[:space:]]{4}container_name:/ { next }  # Remove existing container_name
    inside_service && /^[[:space:]]{4}volumes:/ { inside_service_volumes=1; print; next }  # Detect service volumes
    inside_service_volumes && /^[[:space:]]{6}-[[:space:]]*([a-zA-Z0-9_-]+)/ {
        # Preserve indentation and rename volumes inside services correctly
        match($0, /^([[:space:]]*)- ([a-zA-Z0-9_-]+)/, groups)
        print groups[1] "- " container_name "_" groups[2]  # Maintain indentation
        next
    }
    inside_service_volumes && !/^[[:space:]]{6}-/ { inside_service_volumes=0 }

    # Modify the ME_CONFIG_MONGODB_SERVER value
    inside_service && /^[[:space:]]{6}ME_CONFIG_MONGODB_SERVER:/ {
        gsub(/mongo/, container_name "_mongo")
        print
        next
    }

    { print }

    END { if (inside_service && added_container_name == 0) print "    container_name: " modified_service_name "\n    networks:\n      - " net }
    ' "$compose_file" > tmpfile && mv tmpfile "$compose_file"

    # Ensure the networks section exists at the bottom
    if ! grep -q "^networks:" "$compose_file"; then
        echo -e "\nnetworks:\n  $network_name:\n    external: true" >> "$compose_file"
    elif ! grep -q "$network_name" "$compose_file"; then
        echo -e "  $network_name:\n    external: true" >> "$compose_file"
    fi
}
