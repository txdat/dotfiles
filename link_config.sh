#!/bin/sh

sudo ln -s ~/.dotfiles/.vimrc /root/.vimrc
sudo ln -s ~/.dotfiles/.vim /root/.vim

ln -s ~/.dotfiles/.xprofile ~/.xprofile
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.vim ~/.vim
ln -s ~/.dotfiles/.vimrc ~/.ideavimrc
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/.doom.d ~/.doom.d

# link kate's lsp config
mkdir -p ~/.config/kate/lspclient && ln -s ~/.dotfiles/.config/kate/lspclient/settings.json ~/.config/kate/lspclient/settings.json

# link config in ~/.config
# TODO: remove unused symlinks
for d in ~/.dotfiles/.config/*/; do
    $(ln -s "$d" ~/.config/$(basename "$d"))
done

# update bat config
bat cache --build

# enable nvim's cpp dap
echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

# install doom's emacs
~/.emacs.d/bin/doom install
