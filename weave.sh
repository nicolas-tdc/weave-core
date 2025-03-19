#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

current_dir=$(pwd)

# Execute from project root
cd "$(dirname "$0")"

case "$1" in
  create-app) ./scripts/create-app.sh ;;
  clone-app) ./scripts/clone-app.sh ;;
  update) ./scripts/update.sh
esac

cd "$current_dir"