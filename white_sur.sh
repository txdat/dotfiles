#!/bin/sh
mkdir ~/.themes
cd ~/.themes
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme
cd WhiteSur-gtk-theme && ./install.sh
mkdir ~/.icons
cd ~/.icons
git clone https://github.com/vinceliuice/WhiteSur-icon-theme
git clone https://github.com/vinceliuice/WhiteSur-cursors
cd WhiteSur-icon-theme && ./install.sh
cd ../WhiteSur-cursors && ./install.sh
cd -
