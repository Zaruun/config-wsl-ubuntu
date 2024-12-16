#!/bin/bash

# Check if Ansible is installed
if [ $(dpkg-query -W -f='${Status}' ansible 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    echo "Ansible is not installed. Installing..."

    # Install Ansible
    sudo apt update
    sudo apt install -y ansible

    echo "Ansible installed successfully."
else
    echo "Ansible is already installed."
fi

# Start ansible configuration playbook
ansible-playbook -i localhost _ansible/playbook.yaml --ask-become-pass

# Check if dotfiles dir exist if no clone it
if [[ -d ~/dotfiles ]]; then
    echo "[INFO] dotfiles directory already exist."
else
    repo_url="https://github.com/Zaruun/dotfiles"
    dir="~/dotfiles"
    echo "[INFO] Cloning repository from $repo_url to $dir..."
    git clone "$repo_url" "$dir" || die "Failed to clone repository."

    echo "[INFO] Changing directory to $dir..."
    cd "$dir" || die "Failed to change directory to $dir."

    echo "[INFO] Symlinking dotfiles..."
    stow . || die "Error occurred while symlinking useing GNU stow."
fi
 