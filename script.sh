#!/data/data/com.termux/files/usr/bin/bash

# Termux Docker installation script
# Installs Ubuntu and Docker inside Termux

echo "Updating Termux packages..."
pkg update -y
pkg upgrade -y

echo "Installing required packages..."
pkg install -y proot-distro git curl wget tar

echo "Installing Ubuntu distro in Termux..."
proot-distro install ubuntu
echo "Ubuntu installed!"

echo "Starting Ubuntu..."
proot-distro login ubuntu -- bash <<'EOF'

# Inside Ubuntu
echo "Updating Ubuntu packages..."
apt update -y
apt upgrade -y

echo "Installing prerequisites for Docker..."
apt install -y apt-transport-https ca-certificates curl gnupg lsb-release sudo

echo "Adding Docker GPG key..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

echo "Updating package list..."
apt update -y

echo "Installing Docker..."
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "Docker installed! You can run Docker using root inside Termux Ubuntu."
echo "Example: sudo docker run hello-world"

EOF

echo "Setup complete! To use Docker, run:"
echo "proot-distro login ubuntu"
