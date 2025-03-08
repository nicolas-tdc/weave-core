#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

SOURCE_DIR=$1
DESTINATION_DIR=$2

for FILE in $SOURCE_DIR; do
    FILE_NAME=$(basename "$FILE")
    if ! [ -f "$DESTINATION_DIR/$FILE_NAME" ]; then
        cp "$FILE" "$DESTINATION_DIR/$FILE_NAME"
        chmod 755 "$DESTINATION_DIR/$FILE_NAME"
    fi
done
