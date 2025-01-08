#!/bin/bash

# Description:
# This script synchronizes a local Git repository with a remote repository
# and deletes local branches that are tracking deleted remote branches.
#
# Usage:
# 1. Make the script executable:
#    chmod +x git-sync.sh
# 2. Run the script with the path to the Git project:
#    ./git-sync.sh /path/to/your/git/project

# Ensure a directory is provided
# $1 is the first argument passed to the script
if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-git-repo>"
    exit 1
fi

# Navigate to the Git repository, which is the first argument passed to the script
cd "$1" || exit 1

# Fetch updates and prune remote branches
# prune: deletes remote-tracking branches that no longer exist on the remote
git fetch --prune

# Delete all local branches that are tracking deleted remote branches
# The `git branch -vv` command lists all local branches and their corresponding remote branches in verbose mode.
# grep ': gone]': filters the branches that are tracking deleted remote branches
# awk '{print $1}': extracts the branch name
for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do
    git branch -d "$branch"
done

# Pull the latest changes for the main branch
git checkout main
git pull origin main