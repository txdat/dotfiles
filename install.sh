#!/bin/sh

# install base packages
sudo pacman -S --noconfirm curl wget axel git \
                           lazygit git-delta \
                           zsh tmux htop ranger neofetch \
                           vi vim neovim lua-language-server \
                           zip unzip p7zip ark \
                           bat \
                           xclip xdotool fzf fzy ripgrep fd jq bc less \
                           fcitx5 fcitx5-bamboo fcitx5-mozc fcitx5-configtool fcitx5-qt fcitx5-gtk \
                           xorg-xrandr \
                           openssh \
                           pacman-contrib \
                           xf86-input-synaptics \
                           xf86-video-amdgpu \
                           amd-ucode \
                           bluez bluez-utils

sudo pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra && \
sudo fc-cache -vfs

# enable essential services
sudo systemctl enable sshd.service
sudo systemctl enable fstrim.timer
sudo systemctl enable paccache.timer
sudo systemctl enable bluetooth.service

# nvidia's hook
sudo mkdir -p /etc/pacman.d/hooks
sudo tee -a /etc/pacman.d/hooks/nvidia.hook > /dev/null <<EOL
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=linux
# Change the linux part above and in the Exec line if a different kernel is used

[Action]
Description=Update NVIDIA module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case \$trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
EOL

# set sddm high dpi
sudo mkdir -p /etc/sddm.conf.d
sudo tee -a /etc/sddm.conf.d/dpi.conf > /dev/null <<EOL
[X11]
ServerArguments=-nolisten tcp -dpi 160
EOL

# install paru
sudo pacman -S --noconfirm rustup

# install rust toolchain
rustup toolchain install stable && rustup default stable

# compile paru
git clone https://aur.archlinux.org/paru .paru && cd .paru/ && makepkg -si && cd -

# install essential applications
sudo pacman -S --noconfirm dolphin alacritty firefox chromium \
                           gwenview mpv spectacle \
                           zathura zathura-pdf-mupdf okular calibre \
                           dbeaver

paru -S --noconfirm dropbox spotify anki \
                    postman-bin mongodb-compass

# git config
git config --global user.name "txdat" && \
git config --global user.email "dattranx105@gmail.com" && \
ssh-keygen

# install essential development packages
sudo pacman -S --noconfirm gcc gdb \
                           clang llvm lldb lld \
                           make cmake ccache ctags valgrind strace

sudo pacman -S --noconfirm cblas openblas openmp openmpi lapack lapacke eigen tbb boost \
                           ffmpeg4.4 libuv \
                           gperftools gflags google-glog gtest protobuf \
                           cuda cudnn nvidia-utils \
                           opencv-cuda

sudo pacman -S --noconfirm nvidia

# rust
# rustup component add rust-src
# rustup component add rust-analyzer

# golang
# sudo pacman -S --noconfirm go gopls delve

# zig
# sudo pacman -S --noconfirm zig zls

# javascript, typescript
# sudo pacman -S --noconfirm nodejs npm yarn
# sudo npm install -g typescript typescript-language-server vscode-langservers-extracted typescript-styled-plugin prettier @fsouza/prettierd neovim
# paru -S --noconfirm nvm

# java, scala
# sudo pacman -S --noconfirm jdk17-openjdk maven sbt
# sudo archlinux-java set java-17-openjdk
# paru -S --noconfirm scala3 coursier
# coursier install metals

# haskell
# paru -S --noconfirm ghcup-hs-bin
# ghcup install ghc && ghcup install cabal && ghcup install hls

# python
# axel -n 8 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# chmod a+x ./Miniconda3-latest-Linux-x86_64.sh
# ./Miniconda3-latest-Linux-x86_64.sh
# rm -f ./Miniconda3-latest-Linux-x86_64.sh
# conda update --all -y
# conda config --set auto_activate_base false
# pip install pynvim pyright black debugpy --upgrade

# ml/ds env
# conda create -n mlds python=3.11
# pip install numpy scipy cython numba pandas matplotlib seaborn scikit-learn xgboost catboost lightgbm statsmodels treelite treelite_runtime opencv-python opencv-contrib-python jupyterlab --upgrade
# pip install torch torchvision pytorch-lightning transformers triton taichi --upgrade
# pip install --upgrade "jax[cuda]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

# latex
# sudo pacman -S --noconfirm texlive-core texlive-latexextra texlive-bibtexextra biber texlive-science texlab texlive-binextra
# sudo sed -i -e "s/\$Master\/..\/../\$Master\/..\/..\/../g" /usr/share/texmf-dist/scripts/texlive/tlmgr.pl
# tlmgr init-usertree
# tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
# tlmgr install libertine
# tlmgr install doublestroke

# docker, k3s, ...
# sudo pacman -S --noconfirm docker docker-compose
# sudo usermod -aG docker $USER
# paru -S --noconfirm nvidia-container-runtime nvidia-container-toolkit
# sudo pacman -S --noconfirm kubectl helm skaffold nfs-utils
# curl -sfL https://get.k3s.io | sh -
# sudo mkdir -p /etc/docker && sudo ln -s ~/.dotfiles/k3s/docker/daemon.json /etc/docker/daemon.json
# sudo mkdir -p /etc/containerd && sudo ln -s ~/.dotfiles/k3s/containerd/config.toml /etc/containerd/config.toml

# zsh
mkdir -p .zsh && \
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting && \
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions && \
git clone https://github.com/romkatv/powerlevel10k ~/.zsh/powerlevel10k

# doomemacs
# sudo pacman -S --noconfirm emacs-nativecomp
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
# ln -s ~/.dotfiles/.doom.d ~/.doom.d
# doom install

# install fonts
sudo cp -r ~/.dotfiles/fonts/jetbrains /usr/share/fonts && sudo fc-cache -vfs

# fix emoji displaying
sudo ln -s ~/.dotfiles/75-noto-color-emoji.conf /usr/share/fontconfig/conf.avail/75-noto-color-emoji.conf && \
sudo ln -s ~/.dotfiles/75-noto-color-emoji.conf /etc/fonts/conf.d/75-noto-color-emoji.conf

# enable nvim's dap for c/c++/rust
echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
