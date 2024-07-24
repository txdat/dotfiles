#!/bin/sh

sudo rm -rf /root/.vimrc && sudo ln -s ~/.dotfiles/.vimrc /root/.vimrc
sudo rm -rf /root/.vim && sudo ln -s ~/.dotfiles/.vim /root/.vim

rm -f ~/.gitconfig && ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.xprofile ~/.xprofile
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.vim ~/.vim
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/.vim/colors ~/.config/nvim/colors

active_configs=(
    "alacritty"
    "bat"
    "fcitx5"
    "lazygit"
    "mpv"
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
