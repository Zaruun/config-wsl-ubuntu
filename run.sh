#!/bin/bash

# Function to display an error message and exit the script
die() {
    echo "[ERROR] $1" >&2
    cleanup
    exit 1
}

# Function to clean up the temporary directory
cleanup() {
    if [[ -d "$temp_dir" ]]; then
        echo "[INFO] Cleaning up temporary directory: $temp_dir"
        rm -rf "$temp_dir" || echo "[WARNING] Failed to clean up $temp_dir."
    fi
}

# Function to fetch and run the configuration script
fetch_and_run() {
    local repo_url="https://github.com/Zaruun/config-wsl-ubuntu"
    temp_dir="/tmp/config-wsl-ubuntu"  # Declared globally for cleanup

    echo "[INFO] Cloning repository from $repo_url to $temp_dir..."
    git clone "$repo_url" "$temp_dir" || die "Failed to clone repository."

    echo "[INFO] Changing directory to $temp_dir..."
    cd "$temp_dir" || die "Failed to change directory to $temp_dir."

    echo "[INFO] Running configure.sh..."
    if [[ -f configure.sh ]]; then
        bash configure.sh || die "Error occurred while executing configure.sh."
    else
        die "configure.sh is not executable or not found."
    fi
}

# Main script execution
trap cleanup EXIT  # Ensure cleanup on script exit
fetch_and_run

# End of script
echo "[INFO] The script completed successfully."
exit 0
