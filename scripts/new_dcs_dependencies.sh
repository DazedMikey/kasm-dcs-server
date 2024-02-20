#!/usr/bin/sh

# Download precompiled wine-mono and wine-gecko binaries for wine - ubuntu focal
sudo mkdir -p /opt/wine/mono
sudo mkdir -p /opt/wine/gecko
sudo wget -O - https://dl.winehq.org/wine/wine-mono/8.1.0/wine-mono-8.1.0-x86.tar.xz | sudo tar -xJv -C /opt/wine/mono
sudo wget -O - https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86.tar.xz | sudo tar -xJv -C /opt/wine/gecko
sudo wget -O - https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86_64.tar.xz | sudo tar -xJv -C /opt/wine/gecko

# Add wine repo and download/install wine for ubuntu focal
sudo dpkg --add-architecture i386
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
sudo apt -y update && sudo apt -y install --install-recommends winehq-stable

# Create virtual display for winetricks install
export DISPLAY=:99
Xvfb :99 -screen 0 1000x1000x16 &
xrandr –query
sleep 5
nohup startxfce4 &
sleep 10
xdotool mousemove 493 539 click 1
xrandr –query

# Initialize wine prefix from command line
sudo wineboot -i

# Download and install winetricks
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
sudo apt -y install cabextract
