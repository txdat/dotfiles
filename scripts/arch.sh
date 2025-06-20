#!/bin/sh

# install base packages
sudo pacman -S --noconfirm curl wget \
                           git lazygit git-delta \
                           zsh tmux htop ranger \
                           vi vim neovim \
                           zip unzip ark \
                           xclip fzf ripgrep fd jq bat \
                           fcitx5 fcitx5-unikey fcitx5-configtool fcitx5-qt fcitx5-gtk \
                           openssh pacman-contrib \
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
sudo pacman -S --noconfirm nvidia nvidia-utils

# install flatpak applications
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# zsh
mkdir -p .zsh && \
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting && \
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions && \
git clone --depth=1 https://github.com/zsh-users/zsh-completions ~/.zsh/zsh-completions && \
chsh -s $(which zsh)

# enable nvim's dap for c/c++/rust
# echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope

# c/c++
# sudo pacman -S --noconfirm gcc gdb clang llvm lldb lld make cmake ccache valgrind strace
# sudo pacman -S --noconfirm cblas openblas openmp openmpi eigen protobuf
# sudo pacman -S --noconfirm cuda cudnn opencv-cuda

# rust
# rustup component add rust-src
# rustup component add rust-analyzer

# golang
# sudo pacman -S --noconfirm go gopls

# javascript, typescript
# curl -fsSL https://fnm.vercel.app/install | bash
# fnm use --install-if-missing 22
# npm install -g typescript typescript-language-server vscode-langservers-extracted prettier @fsouza/prettierd neovim

# java
# sudo pacman -S --noconfirm jdk-openjdk

# haskell
# paru -S --noconfirm ghcup-hs-bin
# ghcup install ghc && ghcup install cabal && ghcup install hls

# python
# curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# chmod a+x ./Miniconda3-latest-Linux-x86_64.sh
# ./Miniconda3-latest-Linux-x86_64.sh
# rm -f ./Miniconda3-latest-Linux-x86_64.sh
# conda update --all -y
# conda config --set auto_activate_base false
# pip install pynvim pyright black awscli --upgrade

# python ML/DS
# conda create -n mlds python=3.13
# conda activate mlds
# pip install numpy scipy cython pandas polars pyarrow matplotlib seaborn scikit-learn opencv-python opencv-contrib-python jupyterlab --upgrade
# pip install torch torchvision transformers --upgrade

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
# with nvidia runtime
# paru -S --noconfirm nvidia-container-runtime nvidia-container-toolkit
# sudo mkdir -p /etc/docker && sudo ln -s ~/.dotfiles/k3s/docker/daemon.json /etc/docker/daemon.json
# sudo mkdir -p /etc/containerd && sudo ln -s ~/.dotfiles/k3s/containerd/config.toml /etc/containerd/config.toml

# podman (replacement of docker)
# sudo pacman -S --noconfirm podman

# k8s
# sudo pacman -S --noconfirm kubectl helm terraform
# paru -S --noconfirm google-cloud-cli google-cloud-cli-gke-gcloud-auth-plugin

# k3s
# curl -sfL https://get.k3s.io | sh -

# openssl-1.1 - download from https://archlinux.org/packages/core/x86_64/openssl-1.1/ and run command below
# sudo pacman -U --overwrite '/usr/lib/*' Downloads/openssl-1.1*
