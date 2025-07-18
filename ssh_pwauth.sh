#!/bin/bash

echo "🛠️ Updating cloud-init config to allow password SSH login..."

# Set ssh_pwauth to 1 in /etc/cloud/cloud.cfg if not already set
if ! grep -q "^ssh_pwauth:" /etc/cloud/cloud.cfg; then
    sudo sed -i "/^disable_root:/a ssh_pwauth: 1" /etc/cloud/cloud.cfg
    echo "✅ Added ssh_pwauth: 1 after disable_root"
else
    sudo sed -i 's/^ssh_pwauth:.*/ssh_pwauth: 1/' /etc/cloud/cloud.cfg
    echo "✅ Updated existing ssh_pwauth to 1"
fi

# Reinitialize cloud-init
sudo cloud-init clean
sudo cloud-init init

echo "🔄 Restarting SSH service..."
sudo systemctl restart ssh

echo "🚀 Cloud-init and SSH configuration updated for password login."
