#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

$PATH=$1
$MOD=$2

# Set permissions
echo -e "\e[33mSetting permissions to $MOD for $PATH...\e[0m"
if [ -f "$PATH" ]; then
    chmod -R $MOD $PATH
    chown -R "$USER_INFO" $PATH
fi