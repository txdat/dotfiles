#!/bin/sh

sudo ln -s ~/.dotfiles/.vimrc /root/.vimrc
sudo ln -s ~/.dotfiles/.vim /root/.vim

ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.vim ~/.vim
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf

# link config in ~/.config
for d in ~/.dotfiles/.config/*/; do
    $(ln -s "$d" ~/.config/$(basename "$d"))
done

# install doom's emacs
ln -s ~/.dotfiles/.doom.d ~/.doom.d && ~/.emacs.d/bin/doom install
