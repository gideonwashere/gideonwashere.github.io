#!/bin/sh

# This script is for automatically hosting the game "A Dark Room"
# Source Code: https://github.com/doublespeakgames/adarkroom
# This script is meant for a fresh install of Ubuntu Server 18.04

# Must be run as root
if ! [ $(id -u) = 0 ]; then
    echo 'Must run as root.'
    exit 1
fi

# Get server name form user
echo -n "Enter server name: "
read SERVER_NAME
: ${SERVER_NAME:?'Server name cannot be empty'}

# Ensure server is up to date
apt update && apt -y upgrade

# Install nginx
apt -y install nginx

# Configure firewall
ufw allow ssh
ufw allow 'Nginx Full'
ufw --force enable

# Copy A Dark Room files to /var/www/adarkroom
git clone https://github.com/doublespeakgames/adarkroom.git /var/www/

# Configure nginx
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default

cat > /etc/nginx/sites-available/adarkroom << EOF
server {
    listen 80;
    server_name $SERVER_NAME;
    root /var/www/adarkroom;
    index index.html;
}
EOF

ln -s /etc/nginx/sites-available/adarkroom /etc/nginx/sites-enabled/

systemctl enable --now nginx

echo "Setup done, navigate to http://$SERVER_NAME to test server."
