#!/bin/bash

# Install requirements
sudo yum install -y glib2-devel &>/dev/null
# Backup current GDM theme
sudo cp -av /usr/share/gnome-shell/gnome-shell-theme.gresource{,~}
# Compile new theme GResource
THEME_NAME="$(gsettings get org.gnome.desktop.interface gtk-theme | sed "s/'//g")"
THEME_SRC_DIR="/usr/share/themes/$THEME_NAME/gnome-shell"
# Fetch the XML resource file now that we know where to put it
sudo curl https://raw.githubusercontent.com/braheezy/catppuccin-gtk-rpm/master/gnome-shell-theme.gresource.xml \
          -o "$THEME_SRC_DIR/gnome-shell-theme.gresource.xml"
sudo glib-compile-resources --target="/usr/share/gnome-shell/gnome-shell-theme.gresource" --sourcedir="$THEME_SRC_DIR" "$THEME_SRC_DIR/gnome-shell-theme.gresource.xml"
