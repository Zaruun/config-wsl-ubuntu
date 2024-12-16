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

