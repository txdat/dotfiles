#!/bin/sh

sudo ln -s ~/.dotfiles/.vimrc /root/.vimrc

ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/.doom.d ~/.doom.d && ~/.emacs.d/bin/doom install

# link config in ~/.config
for d in ~/.dotfiles/.config/*/; do
    $(ln -s "$d" ~/.config/$(basename "$d"))
done
