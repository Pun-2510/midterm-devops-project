set -e

echo "=================================================="
echo "[SETUP] Starting project environment setup"

echo "Installing: Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

echo "Installing: Installing required OS packages..."
sudo apt install -y \
  curl \
  ca-certificates \
  git \
  build-essential 

echo "Installing: Installing Node.js 20 (LTS)..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

echo "Notification: Installed versions:"
node -v
npm -v

echo "Installing: Creating application directories..."

APP_BASE="/opt/app"

sudo mkdir -p \
  $APP_BASE/logs \
  $APP_BASE/uploads \
  $APP_BASE/data

sudo chown -R $USER:$USER $APP_BASE

echo "Notification: Created directories:"
echo " - $APP_BASE/logs"
echo " - $APP_BASE/uploads"
echo " - $APP_BASE/data"

echo "Setup completed successfully"
echo "=================================================="