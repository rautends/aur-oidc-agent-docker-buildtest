#!/bin/bash

REPO_URL="https://aur.archlinux.org/oidc-agent-git.git"
BRANCH="master"
COMMIT="53dae4b9b3c92e336df8f7867cec11a858595419"
REPO_DIR="oidc-agent-git"

# Clone the repository if it doesn't exist
if [ ! -d "$REPO_DIR" ]; then
  git clone --branch $BRANCH $REPO_URL
fi

# Enter the repository directory
cd $REPO_DIR

# Check out the specific commit
git checkout $COMMIT

# Copy the PKGBUILD file
cp ../PKGBUILD .

# Clean previous builds and build the package
makepkg -Csi --noconfirm
makepkg --printsrcinfo > .SRCINFO

# Return to the original directory
cd -
