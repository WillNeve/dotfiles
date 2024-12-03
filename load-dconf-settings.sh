SETTINGS_PATH="$HOME/.config/dconf/gnome-settings.dconf"
dconf load / < $SETTINGS_PATH
echo "Loaded dconf settings from $SETTINGS_PATH"
