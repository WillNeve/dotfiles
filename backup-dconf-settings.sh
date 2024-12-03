SETTINGS_PATH="$HOME/.config/dconf/gnome-settings.dconf"
dconf dump / > $SETTINGS_PATH
echo "Backed up dconf settings to $SETTINGS_PATH"
