#!/bin/bash

# Exit immediately if a command fails
set -e

SCRIPT_NAME=$1

# Stop all services
for SERVICE_PATH in ./*/; do
    (
        # Check if it's a directory
        if [ -d "$SERVICE_PATH" ] && [ -f "${SERVICE_PATH}scripts/$SCRIPT_NAME" ]; then
            cd "$SERVICE_PATH"
            "./$SCRIPT_NAME"
            cd - || exit
        fi
    ) &
done

wait
