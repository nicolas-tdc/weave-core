#!/bin/bash

OUTPUT_GITIGNORE="$APP_NAME/.gitignore"

# Clear the output .gitignore file
> "$OUTPUT_GITIGNORE"

# Loop through repositories
for repo in $APP_NAME/*/; do
    if [ -f "$repo/.gitignore" ]; then
        GITIGNORE_FILE="$repo/.gitignore"
        if [ -f "$GITIGNORE_FILE" ]; then
            # Add non-comment and non-emty lines to output
            grep -vE '^\s*#' "$GITIGNORE_FILE" | sed '/^\s*$/d' >> "$OUTPUT_GITIGNORE"
            echo "" >> "$OUTPUT_GITIGNORE"
        fi
    fi
done

# Remove duplicate lines
sort -u "$OUTPUT_GITIGNORE" -o "$OUTPUT_GITIGNORE"

echo -e "\e[32mJoined .gitignore files.\e[0m"