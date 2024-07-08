#!/bin/sh

# install base packages
sudo pacman -S --noconfirm curl wget axel \
                        git lazygit git-delta \
                        zsh fish tmux htop ranger neofetch \
                        vi vim neovim lua-language-server luarocks tree-sitter-cli \
                        zip unzip ark \
                        wl-clipboard xclip fzf ripgrep fd jq yq bc bat \
                        fcitx5 fcitx5-bamboo fcitx5-configtool fcitx5-qt fcitx5-gtk \
                        openssh pacman-contrib amd-ucode \
                        bluez bluez-utils \
                        xdg-desktop-portal-gtk \
                        # xorg-xrandr

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
# sudo mkdir -p /etc/sddm.conf.d
# sudo tee -a /etc/sddm.conf.d/dpi.conf > /dev/null <<EOL
# [X11]
# ServerArguments=-nolisten tcp -dpi 160
# EOL
sudo tee -a /etc/sddm.conf > /dev/null <<EOL
[General]
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell, QT_SCALE_FACTOR=2
EOL

# install paru
sudo pacman -S --noconfirm rustup

# install rust toolchain
rustup toolchain install stable && rustup default stable

# compile paru
git clone --depth=1 https://aur.archlinux.org/paru .paru && cd .paru/ && makepkg -si && cd -

# install essential applications
sudo pacman -S --noconfirm dolphin alacritty chromium gwenview spectacle mpv zathura zathura-pdf-mupdf okular konsole libreoffice-still

flatpak install flathub net.ankiweb.Anki
flatpak install flathub com.dropbox.Client
flatpak install flathub com.spotify.Client
flatpak install flathub com.calibre_ebook.calibre
flatpak install flathub md.obsidian.Obsidian
flatpak install flathub rest.insomnia.Insomnia
flatpak install flathub io.dbeaver.DBeaverCommunity
flatpak install flathub com.mongodb.Compass

# git config
# git config --global user.name "txdat" && \
# git config --global user.email "dattranx105@gmail.com" && \
# ssh-keygen

# install essential development packages
sudo pacman -S --noconfirm gcc gdb clang llvm lldb lld make cmake ccache ctags valgrind strace
sudo pacman -S --noconfirm cblas openblas openmp openmpi lapack lapacke eigen tbb boost ffmpeg4.4 libuv gperftools gflags google-glog gtest protobuf cuda cudnn nvidia-utils opencv-cuda
sudo pacman -S --noconfirm nvidia

# zsh
mkdir -p .zsh && \
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting && \
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions && \
git clone --depth=1 https://github.com/zsh-users/zsh-completions ~/.zsh/zsh-completions && \
chsh -s $(which zsh)

# fish
# chsh -s $(which fish)

# install fonts
sudo cp -r ~/.dotfiles/fonts/* /usr/share/fonts && sudo fc-cache -vfs

# fix emoji displaying
sudo ln -s ~/.dotfiles/75-noto-color-emoji.conf /usr/share/fontconfig/conf.avail/75-noto-color-emoji.conf && \
sudo ln -s ~/.dotfiles/75-noto-color-emoji.conf /etc/fonts/conf.d/75-noto-color-emoji.conf

# enable nvim's dap for c/c++/rust
# echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

# rust
# rustup component add rust-src
# rustup component add rust-analyzer

# golang
# sudo pacman -S --noconfirm go gopls

# zig
# sudo pacman -S --noconfirm zig zls

# javascript, typescript
# sudo pacman -S --noconfirm nodejs npm yarn
# sudo npm install -g typescript typescript-language-server vscode-langservers-extracted prettier @fsouza/prettierd neovim demergi
# curl -fsSL https://fnm.vercel.app/install | bash

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
# pip install pynvim pyright black ansible --upgrade

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

# docker
# sudo pacman -S --noconfirm docker docker-compose
# sudo usermod -aG docker $USER
# paru -S --noconfirm nvidia-container-runtime nvidia-container-toolkit

# k8s
# sudo pacman -S --noconfirm kubectl helm terraform
# sudo pacman -S --noconfirm skaffold nfs-utils
# curl -sfL https://get.k3s.io | sh -
# sudo mkdir -p /etc/docker && sudo ln -s ~/.dotfiles/k3s/docker/daemon.json /etc/docker/daemon.json
# sudo mkdir -p /etc/containerd && sudo ln -s ~/.dotfiles/k3s/containerd/config.toml /etc/containerd/config.toml

# doomemacs
# sudo pacman -S --noconfirm emacs-nativecomp
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
# ln -s ~/.dotfiles/.doom.d ~/.doom.d
# doom install

# openssl-1.1 - download from https://archlinux.org/packages/core/x86_64/openssl-1.1/ and run command below
# sudo pacman -U --overwrite '/usr/lib/*' Downloads/openssl-1.1*
