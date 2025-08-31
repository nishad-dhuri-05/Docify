#!/bin/bash
set -e  # exit on error

cd ..
cd repo
GITHUB_USERNAME=$1
GITHUB_REPOSITORY=$2
GITHUB_TOKEN=$3
GITHUB_APP_ID=$4
GITHUB_BRANCH_NAME="docify"

cd $GITHUB_REPOSITORY
ls

if [ $# -lt 3 ]; then
    echo "Usage: $0 <github_username> <repository_name> <access_token> [app_id]"
    exit 1
fi

# Ensure local repo is clean & updated
git fetch origin

# Make sure we are on the branch with changes (main assumed here)
git checkout main || git checkout -b main

# Stage all changes (like requirements.txt)
git add .

# Configure bot identity
git config --global user.name "docify[bot]"
git config --global user.email "$GITHUB_APP_ID+docify[bot]@users.noreply.github.com"

# Commit changes (ignore error if nothing new)
git commit -m "Docify changes to repository, including requirements.txt" || echo "No changes to commit"

# Delete local docify branch if it exists
if git show-ref --verify --quiet "refs/heads/$GITHUB_BRANCH_NAME"; then
    git branch -D $GITHUB_BRANCH_NAME
fi

# Create fresh docify branch from current state
git checkout -b $GITHUB_BRANCH_NAME

# Push to remote (force overwrite to carry everything)
git push -f https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_USERNAME}/${GITHUB_REPOSITORY}.git $GITHUB_BRANCH_NAME
