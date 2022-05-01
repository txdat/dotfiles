#!/bin/sh
sudo cp 75-noto-color-emoji.conf /usr/share/fontconfig/conf.avail/ && cd /etc/fonts/conf.d/ && sudo ln -s /usr/share/fontconfig/conf.avail/75-noto-color-emoji
