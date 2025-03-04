#!/bin/sh

# install base packages
sudo pacman -S --noconfirm curl wget axel \
                           git lazygit git-delta \
                           zsh tmux htop ranger \
                           vi vim neovim \
                           zip unzip ark \
                           xclip fzf ripgrep fd jq bat \
                           fcitx5 fcitx5-unikey fcitx5-configtool fcitx5-qt fcitx5-gtk \
                           openssh pacman-contrib amd-ucode \
                           bluez bluez-utils

sudo pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra && \
sudo fc-cache -vfs

# enable essential services
sudo systemctl enable sshd.service
sudo systemctl enable fstrim.timer
sudo systemctl enable paccache.timer
sudo systemctl enable bluetooth.service

# # nvidia's hook
# sudo mkdir -p /etc/pacman.d/hooks
# sudo tee -a /etc/pacman.d/hooks/nvidia.hook > /dev/null <<EOL
# [Trigger]
# Operation=Install
# Operation=Upgrade
# Operation=Remove
# Type=Package
# Target=nvidia
# Target=linux
# # Change the linux part above and in the Exec line if a different kernel is used
#
# [Action]
# Description=Update NVIDIA module in initcpio
# Depends=mkinitcpio
# When=PostTransaction
# NeedsTargets
# Exec=/bin/sh -c 'while read -r trg; do case \$trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
# EOL

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

# compile paru for AUR
sudo pacman -S --noconfirm rustup
rustup toolchain install stable && rustup default stable
git clone --depth=1 https://aur.archlinux.org/paru .paru && cd .paru/ && makepkg -si && cd -

# install essential applications
sudo pacman -S --noconfirm dolphin alacritty chromium gwenview spectacle mpv okular libreoffice-still

# install nvidia driver
# sudo pacman -S --noconfirm nvidia nvidia-utils

# install flatpak applications
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# zsh
mkdir -p .zsh && \
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting && \
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions && \
git clone --depth=1 https://github.com/zsh-users/zsh-completions ~/.zsh/zsh-completions && \
chsh -s $(which zsh)

# fish
# chsh -s $(which fish)

# fix emoji displaying
sudo ln -s ~/.dotfiles/75-noto-color-emoji.conf /usr/share/fontconfig/conf.avail/75-noto-color-emoji.conf && \
sudo ln -s ~/.dotfiles/75-noto-color-emoji.conf /etc/fonts/conf.d/75-noto-color-emoji.conf

# enable nvim's dap for c/c++/rust
# echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

# c/c++
# sudo pacman -S --noconfirm gcc gdb clang llvm lldb lld make cmake ccache ctags valgrind strace
# sudo pacman -S --noconfirm cblas openblas openmp openmpi lapack lapacke eigen tbb boost ffmpeg4.4 libuv gperftools gflags google-glog gtest protobuf
# sudo pacman -S --noconfirm cuda cudnn opencv-cuda

# rust
# rustup component add rust-src
# rustup component add rust-analyzer

# golang
# sudo pacman -S --noconfirm go gopls

# javascript, typescript
# curl -fsSL https://fnm.vercel.app/install | bash
# fnm use --install-if-missing 22
# npm install -g typescript typescript-language-server vscode-langservers-extracted prettier @fsouza/prettierd neovim demergi

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
# pip install pynvim pyright black ansible awscli --upgrade

# for ML/DS
# conda create -n mlds python=3.12
# pip install numpy scipy cython numba pandas matplotlib seaborn scikit-learn xgboost catboost lightgbm statsmodels treelite treelite_runtime opencv-contrib-python opencv-python jupyterlab --upgrade
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

# k8s
# sudo pacman -S --noconfirm kubectl helm terraform
# curl -sfL https://get.k3s.io | sh -
# paru -S --noconfirm google-cloud-cli google-cloud-cli-gke-gcloud-auth-plugin aws-cli-v2

# docker/k8s nvidia runtime
# paru -S --noconfirm nvidia-container-runtime nvidia-container-toolkit
# sudo mkdir -p /etc/docker && sudo ln -s ~/.dotfiles/k3s/docker/daemon.json /etc/docker/daemon.json
# sudo mkdir -p /etc/containerd && sudo ln -s ~/.dotfiles/k3s/containerd/config.toml /etc/containerd/config.toml

# doomemacs
# sudo pacman -S --noconfirm emacs-nativecomp
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d
# ln -s ~/.dotfiles/.doom.d ~/.doom.d
# doom install

# openssl-1.1 - download from https://archlinux.org/packages/core/x86_64/openssl-1.1/ and run command below
# sudo pacman -U --overwrite '/usr/lib/*' Downloads/openssl-1.1*
