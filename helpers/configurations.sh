#!/bin/bash

# Exit immediately if a command fails
set -e

# This script contains helper functions for managing weave configurations.

get_application_name() {
    APP_NAME=$(basename "$PWD") > /dev/null 2>&1
    export APP_NAME
}

get_services_directory() {
    SERVICES_DIRECTORY=$(awk -F= '
        /^\[global\]/ { in_section=1; next }
        /^\[/        { in_section=0 }
        in_section && $1 ~ /services_directory/ {
            gsub(/ /, "", $2); print $2
        }
    ' "$WEAVE_CONFIGURATIONS_FILE")
    export SERVICES_DIRECTORY

    # Create the services directory if it doesn't exist
    mkdir -p $SERVICES_DIRECTORY > /dev/null 2>&1
}

get_backups_directory() {
    BACKUPS_DIRECTORY=$(awk -F= '
        /^\[global\]/ { in_section=1; next }
        /^\[/        { in_section=0 }
        in_section && $1 ~ /backups_directory/ {
            gsub(/ /, "", $2); print $2
        }
    ' "$WEAVE_CONFIGURATIONS_FILE")
    export BACKUPS_DIRECTORY

    # Create the backups directory if it doesn't exist
    mkdir -p $BACKUPS_DIRECTORY > /dev/null 2>&1
}

get_available_services() {
    declare -gA AVAILABLE_SERVICES

    local in_section=0
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Trim leading/trailing whitespace
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"

        # Skip comments and empty lines
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        if [[ "$line" == "[available-services]" ]]; then
            in_section=1
            continue
        elif [[ "$line" =~ ^\[.*\] ]]; then
            in_section=0
        fi

        if (( in_section )) && [[ "$line" == *=* ]]; then
            key="${line%%=*}"
            value="${line#*=}"
            key="${key//[[:space:]]/}"
            value="${value//[[:space:]]/}"
            AVAILABLE_SERVICES["$key"]="$value"
        fi
    done < "$WEAVE_CONFIGURATIONS_FILE"
}

get_installed_services() {
    declare -gA INSTALLED_SERVICES
    declare -ga INSTALLED_SERVICE_KEYS

    local in_section=0
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Trim leading/trailing whitespace
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"

        [[ -z "$line" || "$line" =~ ^# ]] && continue

        if [[ "$line" == "[installed_services]" ]]; then
            in_section=1
            continue
        elif [[ "$line" =~ ^\[.*\] ]]; then
            in_section=0
        fi

        if (( in_section )) && [[ "$line" == *=* ]]; then
            key="${line%%=*}"
            value="${line#*=}"
            key="${key//[[:space:]]/}"
            value="${value//[[:space:]]/}"
            INSTALLED_SERVICES["$key"]="$value"
            INSTALLED_SERVICE_KEYS+=("$key")
        fi
    done < "$WEAVE_CONFIGURATIONS_FILE"
}
