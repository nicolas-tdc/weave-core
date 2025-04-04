#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# This script is used to update the weave framework.

echo -e "\e[32mUpdating weave...\e[0m"

git pull origin main

# Ensure submodules are initialized and updated
git submodule update --init --recursive

# Iterate through each submodule
git submodule foreach '
  echo "Pulling latest changes for submodule: $name"
  git checkout main || { echo "Failed to checkout main branch in $name"; exit 1; }
  git pull origin main || { echo "Failed to pull from main in $name"; exit 1; }
'

echo "All submodules updated successfully!"
