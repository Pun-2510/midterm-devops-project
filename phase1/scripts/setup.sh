set -e

echo "=================================================="
echo "[SETUP] Starting project environment setup"

echo "Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

echo "Installing required OS packages..."
sudo apt install -y \
  curl \
  ca-certificates \
  git \
  build-essential

echo "Installing Node.js 20 (LTS)..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

echo "[VERIFY] Installed versions:"
node -v
npm -v

echo "Creating application directories..."

APP_BASE="/opt/myapp"

sudo mkdir -p \
  $APP_BASE/logs \
  $APP_BASE/uploads \
  $APP_BASE/data

sudo chown -R $USER:$USER $APP_BASE

echo "Created directories:"
echo " - $APP_BASE/logs"
echo " - $APP_BASE/uploads"
echo " - $APP_BASE/data"

echo "Setup completed successfully"
echo "=================================================="