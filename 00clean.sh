#!/bin/bash

# Check if the directory oidc-agent-git exists
if [ -d "oidc-agent-git" ]; then
  # Change to the directory oidc-agent-git
  cd oidc-agent-git

  # Check if it is a Git directory
  if [ -d .git ]; then
    # Use git status to check if there are changes
    if ! git diff-index --quiet HEAD --; then
      echo "Changes found. Performing hard reset and removing all untracked files..."

      # Hard reset
      git reset --hard HEAD
    else
      echo "No changes found."
    fi

    # Remove all untracked files, including those listed in .gitignore
    echo "Removing all untracked files and directories..."
    git clean -xfd

    echo "Untracked files and directories removed."
    
    # Remove the src directory if it exists
    if [ -d src ]; then
      echo "Removing src directory..."
      rm -rf src
    else
      echo "src directory not found."
    fi
  else
    echo "No Git directory found. Exiting."
    exit 1
  fi

  # Return to the previous directory
  cd ..
else
  echo "Directory oidc-agent-git does not exist. Exiting."
  exit 1
fi
