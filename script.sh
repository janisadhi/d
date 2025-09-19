#!/bin/bash

# This script installs Docker on Debian/Ubuntu without sudo
# Must be run as root

set -e

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

echo "Updating existing packages..."
apt update -y
apt upgrade -y

echo "Installing prerequisite packages..."
apt install -y ca-certificates curl gnupg lsb-release

echo "Adding Docker's official GPG key..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "Setting up Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

echo "Updating package list..."
apt update -y

echo "Installing Docker Engine..."
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Enabling and starting Docker service..."
systemctl enable docker
systemctl start docker

echo "Adding current user to docker group..."
usermod -aG docker $SUDO_USER

echo "Docker installation completed!"
echo "You may need to log out and log back in for group changes to take effect."
