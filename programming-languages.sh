#!/bin/bash

# Function to display an error message and exit the script
die() {
    echo "[ERROR] $1" >&2
    exit 1
}

# Function to install a plugin and set the version globally
install_asdf_plugin() {
    local plugin_name=$1
    local specified_version=$2
    local version_to_install

    echo "[INFO] Installing or updating asdf plugin: $plugin_name"
    if ! asdf plugin list | grep -q "$plugin_name"; then
        asdf plugin add "$plugin_name" || die "Failed to add asdf plugin: $plugin_name"
    else
        asdf plugin update "$plugin_name" || echo "[WARNING] Failed to update plugin: $plugin_name. Continuing..."
    fi

    # Determine the version to install
    if [[ -z "$specified_version" ]]; then
        echo "[INFO] No version specified for $plugin_name. Fetching the latest version..."
        version_to_install=$(asdf list all "$plugin_name" | grep -v "rc\|beta" | tail -n 1)
        [[ -z "$version_to_install" ]] && die "Could not determine the latest version for $plugin_name"
    else
        version_to_install=$specified_version
    fi

    echo "[INFO] Installing $plugin_name version $version_to_install"
    asdf install "$plugin_name" "$version_to_install" || die "Failed to install $plugin_name $version_to_install"
    asdf global "$plugin_name" "$version_to_install" || die "Failed to set $plugin_name $version_to_install as global"

    echo "[INFO] $plugin_name $version_to_install installed and set globally"
}

# Ensure asdf is installed and sourced
if ! command -v asdf &> /dev/null; then
    die "asdf is not installed. Please install it before running this script."
fi

# Source asdf.sh to use asdf in the script
if [[ -f "$HOME/.asdf/asdf.sh" ]]; then
    source "$HOME/.asdf/asdf.sh"
else
    die "asdf.sh not found in $HOME/.asdf. Please check your asdf installation."
fi

# Plugins to install and their versions (set to empty string for latest version)
declare -A plugins_and_versions=(
    ["nodejs"]=""         # Latest version
    ["golang"]=""         # Latest version
    ["powershell-core"]="7.4.6" # Specific version
)

# Loop through each plugin and install it
for plugin in "${!plugins_and_versions[@]}"; do
    install_asdf_plugin "$plugin" "${plugins_and_versions[$plugin]}"
done

echo "[INFO] All plugins installed and set globally"
