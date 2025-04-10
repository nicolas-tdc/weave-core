#!/bin/bash

# Exit immediately if a command fails
set -e

# This script is used to update a weave service.

env_name="$1"

echo -e "\e[33m$SERVICE_NAME: Trying to update in environment '$env_name'...\e[0m"

# Add update task here
echo -e "\e[32m$SERVICE_NAME: No update task.\e[0m"