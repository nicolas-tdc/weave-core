#!/bin/bash

# Exit immediately on error
set -e

echo -e "\e[33mMerging services' .gitignore files into application's .gitignore...\e[0m"

OUTPUT_GITIGNORE=".gitignore"

# Create the .gitignore file from scratch with the header sections
echo "# Application specifics" > "$OUTPUT_GITIGNORE"
echo "" >> "$OUTPUT_GITIGNORE"
echo "" >> "$OUTPUT_GITIGNORE"

echo "# Services specifics" >> "$OUTPUT_GITIGNORE"

# Collect child .gitignore entries and append to parent .gitignore
{
    for SERVICE in ./$SERVICES_DIR/*/; do
        GITIGNORE_FILE="${SERVICE}.gitignore"
        
        if [ -f "$GITIGNORE_FILE" ]; then
            # Append service name to .gitignore with a line break before
            SERVICE_NAME="${SERVICE#./services/}"
            echo "" >> "$OUTPUT_GITIGNORE"  # Ensure there's a blank line before the service section
            echo "# $SERVICE_NAME" >> "$OUTPUT_GITIGNORE"
            echo "" >> "$OUTPUT_GITIGNORE"  # Blank line after the service name

            # Append .gitignore entries to .gitignore
            while IFS= read -r LINE; do
                [[ -z "$LINE" || "$LINE" =~ ^\s*# ]] && continue
                if [[ "$LINE" == /* ]]; then
                    echo "$LINE" >> "$OUTPUT_GITIGNORE"
                else
                    echo "${SERVICE_NAME}$LINE" >> "$OUTPUT_GITIGNORE"
                fi
            done < "$GITIGNORE_FILE"

            rm "$GITIGNORE_FILE"
        fi
    done
} # End of processing the services
