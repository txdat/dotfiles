#!/bin/sh

sudo ln -s ~/.dotfiles/.vimrc /root/.vimrc
sudo ln -s ~/.dotfiles/.vim /root/.vim

ln -s ~/.dotfiles/.xprofile ~/.xprofile
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.vim ~/.vim
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf

# link config in ~/.config
# TODO: remove unused symlinks
for d in ~/.dotfiles/.config/*/; do
    $(ln -s "$d" ~/.config/$(basename "$d"))
done

# update bat config
bat cache --build

# install doom's emacs
ln -s ~/.dotfiles/.doom.d ~/.doom.d && ~/.emacs.d/bin/doom install
