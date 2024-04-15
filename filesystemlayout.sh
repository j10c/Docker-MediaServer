#!/bin/bash

# Create directories for apps (running the applications) and data (manage torrents and media)
sudo mkdir -p /appdata/radarr /appdata/sonarr /appdata/overseerr /appdata/plex /appdata/qbittorrent /appdata/wireguard
sudo mkdir -p /data/torrents/movies /data/torrents/shows /data/torrents/incomplete /data/media/movies /data/media/shows /data/indexer/incomplete /data/indexer/complete/movies /data/indexer/complete/shows

sudo usermod -aG sudo ${USER}