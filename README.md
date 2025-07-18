# user-pass-create-in-ubuntu

---

# 🔐 User Setup with Password Access on Ubuntu 24.04

This guide outlines the steps to create a new system user on an Ubuntu 24.04 EC2 instance and enable password-based SSH login, even when cloud-init restrictions apply.

---

## 🧾 Prerequisites

- Ubuntu 24.04 EC2 instance running
- SSH access with a `sudo`-enabled user (e.g., `ubuntu`)
- Shell script or terminal access

---

## 👤 Create a New User

Run the following to create a user named `username` with a predefined password:

```bash
sudo adduser --disabled-password --gecos "" username
echo "username:*************" | sudo chpasswd
```

> 🔐 Replace `************` with a strong password of your choice.

---

## 🔄 Enable SSH Password Authentication

Update the SSH configuration to allow password login:

```bash
sudo sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl restart ssh
```

---

## 🧰 Update Cloud-Init (if using EC2 or cloud-based instances)

Cloud-init may override SSH settings on reboot. Ensure password authentication persists:

```bash
# Insert or update ssh_pwauth in cloud.cfg
if ! grep -q "^ssh_pwauth:" /etc/cloud/cloud.cfg; then
  sudo sed -i "/^disable_root:/a ssh_pwauth: 1" /etc/cloud/cloud.cfg
else
  sudo sed -i 's/^ssh_pwauth:.*/ssh_pwauth: 1/' /etc/cloud/cloud.cfg
fi

# Reinitialize cloud-init
sudo cloud-init clean
sudo cloud-init init
```

---

## ✅ Test Login

From your local machine:

```bash
ssh redis@<your-ec2-ip>
```

Use the password you set to log in.

> 🛠 If you receive a host key warning (`REMOTE HOST IDENTIFICATION HAS CHANGED`), run:  
> `ssh-keygen -R <your-ec2-ip>`  
> to remove the stale key from known_hosts.

---

## 🚀 Script It All

For automation, bundle the above into a shell script like `setup_redis_user.sh`. Let me know if you want it integrated or templated for multiple users!

Want help refining this further for your repo or documentation standards? I'm all yours 💬
