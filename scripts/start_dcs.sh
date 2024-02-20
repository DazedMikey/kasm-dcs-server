#!/usr/bin/sh

# Link DCS
ln -s ~/wine/drive_c/Program\ Files/Eagle\ Dynamics/DCS\ World\ OpenBeta\ Server dcs_server

# Give kasm-user access to wine directory
sudo chown -R kasm-user /home/kasm-user/wine

# Open firefox to server command window
firefox ~/dcs_server/WebGUI/index.html &

# DCS command:
# TODO - Change path to be generi user. Also need to update instructions.
LIBERATION_EXPORT_DIR=/home/kasm-user/wine/drive_c/users/sly/Saved\ Games/DCS.openbeta_server \
	WINEARCH="win64" \
	WINEDLLOVERRIDES="wbemprox=n" \
	WINEPREFIX="/home/kasm-user/wine" \
	wine ~/dcs_server/bin/DCS_server.exe --norender
