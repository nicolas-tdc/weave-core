#!/bin/bash

# Exit immediately if a command fails
set -e

SCRIPT_NAME=$1

# Stop all services
for SERVICE_PATH in ./$SERVICES_DIR/*/; do
    # Check if it's a directory
    if [ -d "$SERVICE_PATH" ] && [ -f "${SERVICE_PATH}$SCRIPT_NAME" ]; then
        cd "$SERVICE_PATH"
        "./$SCRIPT_NAME"
        cd - > /dev/null 2>&1
    fi
done
