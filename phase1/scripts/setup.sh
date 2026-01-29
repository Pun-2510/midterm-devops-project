#!/usr/bin/env bash
set -e

echo "=================================================="
echo "[SETUP] Starting project environment setup"

# Update and upgrade system packages
echo "Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

# Install necessary packages
echo "Installing required OS packages..."
sudo apt install -y \
  curl \
  ca-certificates \
  git \
  build-essential \
  nano

# Install Nodejs v20 LTS, npm
echo "Installing Node.js 20 (LTS)..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Confirm installations
echo "[VERIFY] Installed versions:"
node -v
npm -v

# Install process manager PM2 globally
echo "Installing PM2 process manager..."
sudo npm install -g pm2

# Confirm PM2 installation
echo "[VERIFY] PM2 version:"
pm2 -v

# Install MongoDB
echo "Installing MongoDB..."
curl -fsSL https://pgp.mongodb.com/server-7.0.asc \
| sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg] \
https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" \
| sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

sudo apt update -y
sudo apt install -y mongodb-org

sudo systemctl stop mongod || true
sudo systemctl disable mongod || true

echo "[INFO] MongoDB installed but NOT active."

# Install Reverse Proxy Nginx
echo "Installing Nginx reverse proxy..."
sudo apt install -y nginx

sudo systemctl stop nginx || true
sudo systemctl disable nginx || true

echo "[INFO] Nginx installed but NOT active."

# Install HTTPS certificate tool - Caddy
echo "Installing Caddy..."
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
| sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' \
| sudo tee /etc/apt/sources.list.d/caddy-stable.list

sudo apt update -y
sudo apt install -y caddy

sudo systemctl stop caddy || true
sudo systemctl disable caddy || true

echo "[INFO] Caddy installed but NOT active."
echo "[INFO] Nginx and Caddy cannot be active at the same time."

# Create application directories
echo "Creating application directories..."

APP_BASE="/opt/app"

sudo mkdir -p \
  $APP_BASE/uploads

sudo chown -R $USER:$USER $APP_BASE

echo "Created directories:"
echo " - $APP_BASE/uploads"

echo "Setup completed successfully"
echo "=================================================="
