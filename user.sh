#!/bin/bash

# Exit on any error
set -e

# Variables
USERNAME="jayaadduser"
PASSWORD="*********"

echo "🔧 Creating user: $USERNAME"

# Create the user if it doesn't exist
if id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME already exists."
else
    sudo adduser --disabled-password --gecos "" "$USERNAME"
    echo "$USERNAME:$PASSWORD" | sudo chpasswd
    echo "✅ User $USERNAME created and password set."
fi

echo "🔐 Configuring SSH to allow password login..."

# Enable PasswordAuthentication in SSH config
sudo sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config

echo "🔄 Restarting SSH service..."
sudo systemctl restart ssh

echo "🚀 All done! You can now log in using:"
echo "ssh $USERNAME@<your-ec2-ip>"
