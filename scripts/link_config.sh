#!/bin/sh

rm -f ~/.gitconfig
rm -rf ~/.config/fcitx5

ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.xprofile ~/.xprofile
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.vim ~/.vim
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf

active_configs=(
    "alacritty"
    "bat"
    "fcitx5"
    "lazygit"
    "mpv"
    "nvim"
    "ranger"
)

for cfg in "${active_configs[@]}"
do
    $(ln -s ~/.dotfiles/.config/$cfg ~/.config/$(basename "$d"))
done
bat cache --build
