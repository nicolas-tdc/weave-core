#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo -e "\e[33mConfiguring installation specifics...\e[0m"

# Fetch remote branches
branches=$(git ls-remote --heads "$APP_REPOSITORY" | awk -F'/' '{print $NF}')
# Check if branches were found
if [[ -z "$branches" ]]; then
    echo "No branches found in repository: $APP_REPOSITORY"
    exit 1
fi
# Prompt user to pick a branch
echo "Select a branch to clone:"
select BRANCH in $branches; do
    if [[ -n "$BRANCH" ]]; then
        echo "You selected: $BRANCH"
        break
    else
        echo "Invalid selection. Try again."
    fi
done
export BRANCH
