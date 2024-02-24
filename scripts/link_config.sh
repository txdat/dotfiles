#!/bin/sh

sudo ln -s ~/.dotfiles/.vimrc /root/.vimrc
sudo ln -s ~/.dotfiles/.vim /root/.vim

rm -f ~/.gitconfig && ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.xprofile ~/.xprofile
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.vim ~/.vim
#ln -s ~/.dotfiles/.vimrc ~/.ideavimrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf

active_configs=(
    "alacritty"
    "bat"
    "fcitx5"
    "lazygit"
    "mpv"
    "neofetch"
    "nvim"
    "ranger"
    "zathura"
)

rm -rf ~/.config/fcitx5

for cfg in "${active_configs[@]}"
do
    $(ln -s ~/.dotfiles/.config/$cfg ~/.config/$(basename "$d"))
done
bat cache --build

# jupyterlab
#mkdir -p ~/.jupyter/lab/user-settings && ln -s ~/.dotfiles/.jupyter/lab/user-settings/@jupyterlab ~/.jupyter/lab/user-settings/@jupyterlab
