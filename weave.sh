#!/bin/bash

current_dir=$(pwd)

# Ensure we are executing from the root of the project
cd "$(dirname "$0")"

case "$1" in
  init) ./weave/initialize-app.sh ;;
  install) ./weave/install-app.sh ;;
esac

cd "$current_dir"