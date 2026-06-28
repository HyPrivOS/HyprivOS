#!/bin/bash
set -e

# --- ASCII Art ---
cat << "EOF"
                                                             %%%                  
                                                             %%%%%%%%             
                                                             %%%%%%%%             
                             %%%%%%%%%%%%%%%%%%%%%%%%%       %%%%%%%%             
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       %%%%%%%              
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        %%%%%%%              
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       %%%%%%%%              
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%                           %%%%%%%%      %%%%    
   %%%%%%%%%%%%%%%%%%     %%%%%%                           %%%%%%%%%      %%%%%%% 
   %%%%%%%%%%%%            %%%%%                           %%%%%%%%       %%%%%%%%
    %%%%%%%                %%%%%%%                         %%%%%%%%      %%%%%%%%%
    %%                   %%%%%%%%%%%%%%%%%%%%%%%%%%       %%%%%%%%       %%%%%%%% 
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       %%%%%%%%%       %%%%%%%% 
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       %%%%%%%%       %%%%%%%%  
          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       %%%%%%%%%       %%%%%%%%  
      %%%%%%%%%%%%%%%%%%%%%                            %%%%%%%%%       %%%%%%%%%  
   %%%%%%%%%%%%%%%%%                                  %%%%%%%%%%       %%%%%%%%   
%%%%%%%%%%%%%%%                                       %%%%%%%%%%%%   %%%%%%%%%    
 %%%%%%%%%%                                          %%%%%%%%%%%%%%%%%%%%%%%%%    
 %%%%%%%                  %%%%       %%%%%%%%%      %%%%%%%%%%%%%%%%%%%%%%%%%     
  %%%                  %%%%%%%%       %%%%%%%      %%%%%%%%%     %%%%%%%%%%%      
               %%       %%%%%%%%       %%%%       %%%%%%%%%       %%%%%%%%%       
            %%%%%%       %%%%%%%%       %%       %%%%%%%%%        %%%%%%%%%       
           %%%%%%%%       %%%%%%%%              %%%%%%%%%        %%%%%%%%%        
           %%%%%%%%%       %%%%%%%%%          %%%%%%%%%%        %%%%%%%%%         
             %%%%%%%%       %%%%%%%%%        %%%%%%%%%%        %%%%%%%%%          
             %%%%%%%%%       %%%%%%%%%        %%%%%%%         %%%%%%%%%           
              %%%%%%%%%       %%%%%%%%%%        %%%%         %%%%%%%%%            
               %%%%%%%%%        %%%%%%%%%         %        %%%%%%%%%%             
                %%%%%%%%%       %%%%%%%%%%%               %%%%%%%%%%              
                  %%%%%%%%%   %%%%%%%%%%%%%%             %%%%%%%%%                
                   %%%%%%%%%%%%%%%%%%%%%%%%%%%          %%%%%%%%%                 
                    %%%%%%%%%%%%%%    %%%%%%%%%%          %%%%%%                  
                      %%%%%%%%%%        %%%%%%%%%%           %                    
                       %%%%%%%%%%        %%%%%%%%%%%%                             
                        %%%%%%%%%%         %%%%%%%%%%%%                           
                          %%%%%%%%%%         %%%%%%%%%%%%%                        
                            %%%%%%%%%%          %%%%%%%%%%%%                      
                             %%%%%%%%%%           %%%%%%%%%%%%%                   
                               %%%%%%%%%%%          %%%%%%%%%%                    
                                 %%%%%%%%%%%           %%%%%                      
                                   %%%%%%%%%%%                                    
                                     %%%%%%%%%%%%                                 
                                       %%%%%%%%%                                  
                                          %                                       
EOF

APP_DIR="/opt/hypriv-os"
APP_VERSION="1.0.0"

# Detect OS
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS_DESC="${PRETTY_NAME:-$NAME}"
else
  OS_DESC="Unknown Linux"
fi

# Detect Architecture
ARCH=$(uname -m)
case $ARCH in
  x86_64) ARCH="amd64" ;;
  aarch64) ARCH="arm64" ;;
  *) echo -e "\e[1;31mUnsupported architecture: $ARCH\e[0m"; exit 1 ;;
esac

echo -e "\n\e[1;36mHyPriv OS\e[0m"
echo -e "\e[1;36mUniversal Linux Server Management Platform\e[0m\n"
echo -e "Version: \e[1;33m$APP_VERSION\e[0m"
echo -e "Architecture: \e[1;33m$ARCH\e[0m"
echo -e "Operating System: \e[1;33m$OS_DESC\e[0m\n"

echo -e "Checking Environment..."

# 1. Check Ubuntu/Debian
if [ "$ID" != "ubuntu" ] && [ "$ID" != "debian" ]; then
  echo -e "✖ Ubuntu/Debian not detected."
  exit 1
fi
echo -e "✔ Ubuntu"

# 2. Dependencies
sudo apt-get update -y -q > /dev/null
sudo apt-get install -y -q curl git unzip tar nginx certbot python3-certbot-nginx > /dev/null
echo -e "✔ Dependencies"

# Create Dedicated User
if ! id "hypriv" >/dev/null 2>&1; then
  sudo useradd -r -m -d "$APP_DIR" -s /bin/false hypriv
fi

sudo mkdir -p "$APP_DIR"
sudo chown -R hypriv:hypriv "$APP_DIR"
cd "$APP_DIR"

# Download Release and Checksum
RELEASE_URL="https://download.hypriv.com/releases/latest/hypriv-linux-${ARCH}.tar.gz"
CHECKSUM_URL="https://download.hypriv.com/releases/latest/hypriv-linux-${ARCH}.tar.gz.sha256"

# echo -e "Downloading official release package..."
# curl -sSL -o hypriv.tar.gz "$RELEASE_URL"
# curl -sSL -o hypriv.tar.gz.sha256 "$CHECKSUM_URL"
# sha256sum -c hypriv.tar.gz.sha256 || { echo -e "\e[1;31mChecksum verification failed.\e[0m"; exit 1; }
# tar -xzf hypriv.tar.gz -C "$APP_DIR"
# rm -f hypriv.tar.gz hypriv.tar.gz.sha256

# Note: Since the official package isn't available right now for local dev testing, 
# I am skipping the actual curl for this script execution to not fail abruptly.
# To test locally, the repo files should already be in APP_DIR. 
# We copy them just for this transition phase from the CWD if run locally.
if [ -d "/home/ayesha/Projects/ngnix-Server" ]; then
  sudo cp -r /home/ayesha/Projects/ngnix-Server/* "$APP_DIR/"
  sudo chown -R hypriv:hypriv "$APP_DIR"
fi

# 3. Node Runtime Check
NODE_DIR="$APP_DIR/.node"
export PATH="$NODE_DIR/bin:$PATH"

if ! command -v node >/dev/null 2>&1 || [ "$(node -v | cut -d'.' -f1)" != "v20" ]; then
  mkdir -p "$NODE_DIR"
  if [ "$ARCH" = "amd64" ]; then
    NODE_URL="https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-x64.tar.xz"
  else
    NODE_URL="https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-arm64.tar.xz"
  fi
  curl -fsSL "$NODE_URL" | tar -xJ -C "$NODE_DIR" --strip-components=1
  sudo chown -R hypriv:hypriv "$NODE_DIR"
fi
echo -e "✔ Node Runtime"

# 4. PM2
sudo -u hypriv bash -c "export PATH=$NODE_DIR/bin:\$PATH && cd $APP_DIR && npm install >/dev/null 2>&1"
sudo -u hypriv bash -c "export PATH=$NODE_DIR/bin:\$PATH && cd $APP_DIR && npm install pm2 >/dev/null 2>&1"
echo -e "✔ PM2"

echo -e "✔ Installing"

# Setup Directories
sudo -u hypriv mkdir -p "$APP_DIR/data" "$APP_DIR/logs" "$APP_DIR/backups" "$APP_DIR/uploads"

# Auth and Env Config
read -p "Application Port [Default: 3654]: " APP_PORT
APP_PORT=${APP_PORT:-3654}

read -p "Administrator Username [Default: admin]: " ADMIN_USER
ADMIN_USER=${ADMIN_USER:-admin}

read -s -p "Administrator Password (leave blank to generate random): " ADMIN_PASS
echo ""
if [ -z "$ADMIN_PASS" ]; then
  ADMIN_PASS=$(openssl rand -base64 12)
  echo -e "Generated Random Password: \e[1;33m$ADMIN_PASS\e[0m"
fi

SESSION_SECRET=$(openssl rand -hex 32)
cat << EOF | sudo -u hypriv tee "$APP_DIR/.env" > /dev/null
PORT=$APP_PORT
SESSION_SECRET=$SESSION_SECRET
NODE_ENV=production
EOF

sudo -u hypriv bash -c "export PATH=$NODE_DIR/bin:\$PATH && node -e \"
const fs = require('fs');
const bcrypt = require('bcryptjs');
const passHash = bcrypt.hashSync('$ADMIN_PASS', 10);
const auth = { adminUser: '$ADMIN_USER', adminPassHash: passHash, twoFactorEnabled: false };
fs.writeFileSync('$APP_DIR/data/auth.json', JSON.stringify(auth, null, 2));
\""

# Firewall
if command -v ufw >/dev/null 2>&1; then
  sudo ufw allow $APP_PORT/tcp >/dev/null 2>&1
fi

# CLI Wrapper
cat << 'EOF' | sudo tee /usr/local/bin/hypriv > /dev/null
#!/bin/bash
if [ "$1" = "reset-password" ]; then
  sudo -u hypriv /opt/hypriv-os/.node/bin/node /opt/hypriv-os/reset-password.js
elif [ "$1" = "update" ]; then
  echo "Update logic will be implemented here."
elif [ "$1" = "uninstall" ]; then
  echo "Uninstall logic will be implemented here."
else
  echo "Usage: hypriv {reset-password|update|uninstall}"
fi
EOF
sudo chmod +x /usr/local/bin/hypriv

echo -e "✔ Creating Service"

SERVICE_FILE="/etc/systemd/system/hypriv-os.service"
cat << EOF | sudo tee $SERVICE_FILE > /dev/null
[Unit]
Description=HyPriv OS Daemon
After=network.target

[Service]
Type=forking
User=hypriv
Environment=PATH=$NODE_DIR/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
WorkingDirectory=$APP_DIR
ExecStart=$APP_DIR/node_modules/.bin/pm2 start app.js --name "HyPriv-OS"
ExecStop=$APP_DIR/node_modules/.bin/pm2 stop "HyPriv-OS"
Restart=always
StandardOutput=append:$APP_DIR/logs/server.log
StandardError=append:$APP_DIR/logs/server.log

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable hypriv-os.service >/dev/null 2>&1
sudo systemctl start hypriv-os.service
sudo -u hypriv bash -c "export PATH=$NODE_DIR/bin:\$PATH && cd $APP_DIR && ./node_modules/.bin/pm2 save >/dev/null 2>&1"

echo -e "✔ Starting HyPriv OS\n"

IP_ADDR=$(curl -s http://checkip.amazonaws.com || echo "SERVER-IP")

echo -e "====================================================="
echo -e "\nHyPriv OS Installed Successfully\n"
echo -e "Dashboard:"
echo -e "http://$IP_ADDR:$APP_PORT\n"
echo -e "Username:"
echo -e "$ADMIN_USER\n"
echo -e "Management:\n"
echo -e "systemctl restart hypriv-os\n"
echo -e "systemctl status hypriv-os\n"
echo -e "journalctl -u hypriv-os\n"
echo -e "hypriv reset-password\n"
echo -e "hypriv update\n"
echo -e "hypriv uninstall\n"
echo -e "====================================================="
