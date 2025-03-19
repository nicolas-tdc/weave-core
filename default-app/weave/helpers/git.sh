#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

select_remote_branch() {
    if [ -z "$1" ]; then
        echo -e "\e[31mselect_remote_branch() - Error: First argument is required.\e[0m"
        echo -e "\e[31musage: select_remote_branch <repository_url>\e[0m"
        exit 1
    fi

    repository_url="$1"

    # Fetch remote branches
    branches=$(git ls-remote --heads "$repository_url" | awk -F'/' '{print $NF}')
    # Check if branches were found
    if [[ -z "$branches" ]]; then
        echo -e "No branches found in repository: $repository_url"
        exit 1
    fi

    # Service branch name input
    echo -e "\e[33mPlease select a branch to pull from:\e[0m"

    select branch in $branches; do
        if ! [ -n "$branch" ]; then
            echo "Invalid selection. Please try again."
            continue
        fi

        export SELECTED_BRANCH=$branch
        break
    done
}

authenticate_ssh_agent() {
    # Input ssh private key path
    echo -e "Enter your ssh private key path (default: ~/.ssh/id_ed25519): \c"
    read ssh_private_key_path
    ssh_private_key_path=${ssh_private_key_path:-$HOME/.ssh/id_ed25519}  # Expand tilde properly

    # Expand tilde manually if it exists at the beginning
    if [[ "$ssh_private_key_path" == ~* ]]; then
        ssh_private_key_path="${HOME}${ssh_private_key_path:1}"
    fi

    # Ensure the key file exists
    if [ ! -f "$ssh_private_key_path" ]; then
        echo "Error: SSH key not found at '$ssh_private_key_path'"
        exit 1
    fi

    # Setup ssh agent
    eval "$(ssh-agent -s)"
    export SSH_AUTH_SOCK
    ssh-add "$ssh_private_key_path"
}

merge_gitignore_files() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "\e[31mmerge_gitignore_files() - Error: First and second argument are required.\e[0m"
        echo -e "\e[31musage: merge_gitignore_files <services_directory> <output_gitignore>\e[0m"
        exit 1
    fi

    services_directory=$1
    output_gitignore=$2

    # Create the .gitignore file with header sections
    echo "# Application specifics" > "$output_gitignore"
    echo "" >> "$output_gitignore"
    echo "" >> "$output_gitignore"
    echo "# Services specifics" >> "$output_gitignore"

    # Collect child .gitignore entries and append to parent .gitignore
    {
        for service in $services_directory/*/; do
            input_gitignore="${service}.gitignore"
            
            if [ -f "$input_gitignore" ]; then
                # Append service name to output gitignore
                service_name="${service#./services/}"
                echo "" >> "$output_gitignore"
                echo "# $service" >> "$output_gitignore"
                echo "" >> "$output_gitignore"

                # Append input gitignore entries to output gitignore
                while IFS= read -r line; do
                    [[ -z "$line" || "$line" =~ ^\s*# ]] && continue
                    if [[ "$line" == /* ]]; then
                        echo "$line" >> "$output_gitignore"
                    else
                        echo "${service_name}$line" >> "$output_gitignore"
                    fi
                done < "$input_gitignore"

                # Remove child .gitignore
                rm "$input_gitignore"
            fi
        done
    }

}

initialize_application_repository() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "\e[31minitialize_application_repository() - Error: First and second argument are required.\e[0m"
        echo -e "\e[31musage: initialize_application_repository <application_repository> <main_branch,staging_branch,dev_branch>\e[0m"
        exit 1
    fi

    # Input application repository and branches
    application_repository=$1
    IFS=',' read -r -a branch_array <<< "$2"
    main_branch="${branch_array[0]}"
    staging_branch="${branch_array[1]}"
    dev_branch="${branch_array[2]}"

    # # Initialize git repository and create defined branches
    echo -e "\e[33mInitializing and pushing application with services to repository...\e[0m"
    # Commit and push app with services to repository
    git init --initial-branch="$main_branch"
    git add .
    git commit -m "Initial commit"
    git remote add origin "$application_repository"
    # Main branch
    git push -u origin "$main_branch"
    # Staging branch
    git checkout -b "$staging_branch"
    git push -u origin "$main_branch:$staging_branch"   
    # Development branch
    git checkout "$main_branch"
    git checkout -b "$dev_branch"
    git push -u origin "$main_branch:$dev_branch"
}