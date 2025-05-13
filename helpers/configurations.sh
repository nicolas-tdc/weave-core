#!/bin/bash

# Exit immediately if a command fails
set -e

# This script contains helper functions for managing weave configurations.

# Function: get_application_name
# Purpose: Retrieves the application name from the current directory.
# Arguments:
#   None
# Returns:
#   None
# Usage: get_application_name
# Note: This function is used to retrieve the application name from the current directory.
get_application_name() {
    APP_NAME=$(basename "$PWD") > /dev/null 2>&1
    export APP_NAME
}

# Function: get_services_directory
# Purpose: Retrieves the services directory from the weave configurations file.
# Arguments:
#   None
# Returns:
#   None
# Usage: get_services_directory
# Note: This function is used to retrieve the services directory from the weave configurations file.
# It creates the services directory if it doesn't exist.
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

# Function: get_backups_directory
# Purpose: Retrieves the backups directory from the weave configurations file.
# Arguments:
#   None
# Returns:
#   None
# Usage: get_backups_directory
# Note: This function is used to retrieve the backups directory from the weave configurations file.
# It creates the backups directory if it doesn't exist.
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

# Function: get_available_services
# Purpose: Retrieves available services from the weave configurations file.
# Arguments:
#   None
# Returns:
#   None
# Usage: get_available_services
# Note: This function is used to retrieve available services from the weave configurations file.
# It populates the AVAILABLE_SERVICES associative array with service names and URLs.
# It also populates the AVAILABLE_SERVICE_KEYS array with the keys of the available services.
get_available_services() {
    declare -gA AVAILABLE_SERVICES

    local in_section=0
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Trim leading/trailing whitespace
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"

        # Skip comments and empty lines
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        # Check if we are in the [available-services] section
        if [[ "$line" == "[available-services]" ]]; then
            in_section=1
            continue
        elif [[ "$line" =~ ^\[.*\] ]]; then
            in_section=0
        fi

        # If we are in the [available-services] section, process key-value pairs
        if (( in_section )) && [[ "$line" == *=* ]]; then
            key="${line%%=*}"
            value="${line#*=}"
            key="${key//[[:space:]]/}"
            value="${value//[[:space:]]/}"
            AVAILABLE_SERVICES["$key"]="$value"
        fi
    done < "$WEAVE_CONFIGURATIONS_FILE"
}

# Function: get_installed_services
# Purpose: Retrieves installed services from the weave configurations file.
# Arguments:
#   None
# Returns:
#   None
# Usage: get_installed_services
# Note: This function is used to retrieve installed services from the weave configurations file.
# It populates the INSTALLED_SERVICES associative array with service names and values.
# It also populates the INSTALLED_SERVICE_KEYS array with the keys of the installed services.
get_installed_services() {
    declare -gA INSTALLED_SERVICES
    declare -ga INSTALLED_SERVICE_KEYS

    local in_section=0
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Trim leading/trailing whitespace
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"

        # Skip comments and empty lines
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        # Check if we are in the [installed_services] section
        if [[ "$line" == "[installed_services]" ]]; then
            in_section=1
            continue
        elif [[ "$line" =~ ^\[.*\] ]]; then
            in_section=0
        fi

        # If we are in the [installed_services] section, process key-value pairs
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
