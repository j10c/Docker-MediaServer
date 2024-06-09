#!/bin/bash

# Run the script as SUDO
sudo -s

# Create directories 
mkdir -p /docker/appdata/{radarr,sonarr,prowlarr,overserr,qbittorrent,nzbget,portainer,plex}
mkdir -p /mnt/{volume1,cache}

### Applications ###
# Install applications
apt install curl
apt install net-tools
apt install openssh-server

# apt update/upgrades 
apt update
apt upgrade

# Docker install
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker part 2
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Permissions
groupadd docker
usermod -aG sudo,docker jc-admin
chown -R jc-admin /mnt/volume1 /docker/appdata/ /home/jc-admin/.docker
chmod g+rwx "$HOME/.docker" -R
chmod 775 /var/run/docker.sock

# Install portainer and make it always run
apt-get update
apt-get upgrade
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# Firewall - enable SSH, Wireguard, Plex & Portainer
ufw allow ssh,51820,32400,9443
ufw enable

# appearance=dark, dock icons size=24, terminal=favorites
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed s/.$//), 'org.gnome.Terminal.desktop']"
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed -e "s/'yelp.desktop', //")"
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed -e "s/'org.gnome.Software.desktop', //")"
