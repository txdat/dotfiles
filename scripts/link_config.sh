#!/bin/sh

sudo ln -s ~/.dotfiles/.vimrc /root/.vimrc
sudo ln -s ~/.dotfiles/.vim /root/.vim

ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.xprofile ~/.xprofile
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.vim ~/.vim
ln -s ~/.dotfiles/.vimrc ~/.ideavimrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf

# link config in ~/.config
for d in ~/.dotfiles/.config/*/; do
    $(ln -s "$d" ~/.config/$(basename "$d"))
done
bat cache --build

# jupyterlab
mkdir -p ~/.jupyter/lab/user-settings && \
ln -s ~/.dotfiles/.jupyter/lab/user-settings/@jupyterlab ~/.jupyter/lab/user-settings/@jupyterlab
