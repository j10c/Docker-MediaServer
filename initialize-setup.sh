#!/bin/bash

# Assign current user to Sudo group
sudo usermod -aG sudo ${USER}

# Create directories for apps (running the applications) and data (manage torrents and media)
sudo mkdir -p /docker/appdata/radarr /docker/appdata/sonarr /docker/appdata/overseerr /docker/appdata/plex /docker/appdata/qbittorrent /docker/appdata/wireguard /docker/appdata/nzbget

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
sudo apt install curl -y
sudo apt install net-tools -y
sudo apt install openssh-server -y
sudo apt install nfs-common -y

## Configure applications ##
# OpenSSH Server :: firewall exception
sudo ufw allow OpenSSH

# Docker install
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

# Docker part 2
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

### External Drive
sudo mkdir /media/media01

### External drive permissions
sudo chown -R $USER:$USER /mnt/media01
sudo chmod -R a=,a+rX,u+w,g+w /mnt/media01
ß
#Docker group for permissions
sudo groupadd docker
sudo usermod -aG ${USER}
su -s ${USER}
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R
sudo chmod 666 /var/run/docker.sock

### End of Applications ###
sudo apt upgrade -y
