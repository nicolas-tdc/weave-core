#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Execute from project root in a subshell
(
  cd "$(dirname "$0")"

  case "$1" in
    create-app) ./scripts/create-app.sh ;;
    clone-app) ./scripts/clone-app.sh ;;
    update) ./scripts/update.sh;;
    *) 
      echo "Error: Invalid or missing argument. Usage: ./weave.sh $0 {create-app|clone-app|update}" 
      exit 1 
      ;;
  esac
)
