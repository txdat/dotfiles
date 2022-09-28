#!/bin/sh

#install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/romkatv/powerlevel10k ~/.oh-my-zsh/custom/themes/powerlevel10k
cp catppuccin-zsh-syntax-highlighting.zsh ~/.oh-my-zsh/
cp .zshrc ~

#copy config to home
cp .vimrc ~
cp .tmux.conf* ~
cp -r .config/alacritty/ ~/.config/
cp -r .config/nvim/ ~/.config/
cp -r .config/zathura/ ~/.config/

#copy config to root
sudo cp .vimrc /root/

#install fonts
sudo cp -r fonts/roboto/ /usr/share/fonts/
sudo cp -r fonts/cascadia/ /usr/share/fonts/
sudo cp -r fonts/jetbrains/ /usr/share/fonts/
sudo fc-cache -vfs

#fix kde's emoji display
sudo cp 75-noto-color-emoji.conf /usr/share/fontconfig/conf.avail
sudo ln -s /usr/share/fontconfig/conf.avail/75-noto-color-emoji.conf /etc/fonts/conf.d/75-noto-color-emoji.conf
