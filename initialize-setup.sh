#!/bin/bash

# Implement file system structure for MediaServer :: AND PERMISSIONS
# Assign static IP address

# appearance=dark, dock icons size=24, terminal=favorites
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed s/.$//), 'org.gnome.Terminal.desktop']"
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed -e "s/'yelp.desktop', //")"
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed -e "s/'org.gnome.Software.desktop', //")"

# apt update/upgrades 
sudo apt update -y

### Applications ###

# Install applications (Networking tools & Docker)
sudo apt install curl net-tools openssh-server xrdp docker.io -y

## Configure applications

# OpenSSH Server :: firewall exception
sudo ufw allow ssh
# Remote desktop protocol :: On startup, firewall exception @3389/tcp
sudo systemctl enable xrdp
sudo systemctl start xrdp
sudo ufw allow 3389/tcp
sudo ufw enable -y
sudo /etc/init.d/xrdp restart


# Docker :: Install compose from github, make directory for it, modify permissions
sudo systemctl enable --now docker
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
sudo chmod +x ~/.docker/cli-plugins/docker-compose 
sudo chmod 666 /var/run/docker.sock


## Output log to .txt file on desktop of all changes.

# Firewall changes