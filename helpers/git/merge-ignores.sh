#!/bin/bash

# Exit immediately on error
set -e

OUTPUT_GITIGNORE="$APP_NAME/.gitignore"

# Clear the output .gitignore file
> "$OUTPUT_GITIGNORE"

# Loop through all subdirectories in $APP_NAME
for repo in "$APP_NAME"/*/; do
    GITIGNORE_FILE="${repo}.gitignore"
    
    if [ -f "$GITIGNORE_FILE" ]; then
        while IFS= read -r line; do
            # Skip empty lines and comments
            [[ -z "$line" || "$line" =~ ^\s*# ]] && continue
            
            # Adjust relative paths by prefixing with subdirectory name
            if [[ "$line" == /* ]]; then
                echo "$line"
            else
                echo "${repo#$APP_NAME/}$line"
            fi
        done < "$GITIGNORE_FILE"
        
        echo ""  # Ensure separation
    fi
done | sort -u > "$OUTPUT_GITIGNORE"
