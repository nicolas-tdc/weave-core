#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script is used to update available-services exclusively from weave-core project.

echo -e "\e[33mUpdating weave-core submodules...\e[0m"

if [ -f "./helpers/git.sh" ]; then
    source ./helpers/git.sh
else
    echo -e "\e[31mError: weave-core/helpers/git.sh not found.\e[0m"
    exit 1
fi

# Update weave-core
update_git_submodules

echo -e "\e[32mUpdated weave-core submodules successfully.\e[0m"
