#!/bin/sh

# update server for pacman
# Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch

# install base packages ---------------------------------------
sudo pacman -S --noconfirm curl wget axel rsync \
                           git lazygit git-delta \
                           zsh tmux htop ranger neofetch \
                           vi vim neovim luarocks lua-language-server \
                           emacs-nativecomp \
                           zip unzip p7zip ark \
                           bat man \
                           xclip xdotool fzf fzy ripgrep fd jq \
                           maim graphviz gnuplot \
                           fcitx5 fcitx5-bamboo fcitx5-configtool fcitx5-qt fcitx5-gtk \
                           xorg-xrandr \
                           openssh \
                           pacman-contrib \
                           xf86-input-synaptics \
                           amd-ucode xf86-video-amdgpu \
                           bluez bluez-utils \
                           # qemu-full \
                           # flatpak

sudo pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra && \
sudo fc-cache -vfs

# enable essential services ----------------------------------
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

# for yoga14 -----------------------------------------------
# set sddm high dpi
sudo mkdir -p /etc/sddm.conf.d
sudo tee -a /etc/sddm.conf.d/dpi.conf > /dev/null <<EOL
[X11]
ServerArguments=-nolisten tcp -dpi 160
EOL

sudo pacman -S --noconfirm tlp tlp-rdw

# enable tlp service
sudo tee -a /etc/tlp.conf > /dev/null <<EOL
START_CHARGE_THRESH_BAT0=0  # dummy value
STOP_CHARGE_THRESH_BAT0=1

NATACPI_ENABLE=1
TPACPI_ENABLE=1
TPSMAPI_ENABLE=1
EOL

sudo systemctl enable tlp.service

# install paru -------------------------------------------
sudo pacman -S --noconfirm rustup

# install rust toolchain
rustup toolchain install stable && rustup default stable

# compile paru
git clone https://aur.archlinux.org/paru .paru && cd .paru/ && makepkg -si && cd -

# install essential applications ------------------------
sudo pacman -S --noconfirm dolphin \
                           alacritty \
                           chromium \
                           gwenview mpv spectacle \
                           zathura zathura-pdf-mupdf \
                           zenity ffmpeg4.4 \
                           calibre \
                           dbeaver

paru -S --noconfirm google-chrome \
                    dropbox \
                    spotify \
                    mongodb-compass \
                    postman-bin \
                    anki

# git config --------------------------------------------
git config --global user.name "txdat" && \
git config --global user.email "dattranx105@gmail.com" && \
ssh-keygen

# install essential development packages ----------------
sudo pacman -S --noconfirm gcc gcc-fortran gdb \
                           clang llvm lldb lld \
                           make cmake ccache ctags valgrind strace

sudo pacman -S --noconfirm cblas openblas \
                           openmp openmpi \
                           lapack lapacke eigen tbb \
                           boost \
                           ffmpeg4.4 libuv \
                           gperftools gflags google-glog gtest protobuf \
                           cuda cudnn magma-cuda nccl nvidia-utils \
                           opencv-cuda \
                           vulkan-icd-loader vulkan-radeon amdvlk

sudo pacman -S --noconfirm nvidia

# rust
# rustup component add rust-src
# rustup component add rust-analyzer
# rustup component add clippy

# golang
# sudo pacman -S --noconfirm go gopls

# javascript/typescript
# sudo pacman -S --noconfirm nodejs npm yarn
# sudo npm install -g typescript typescript-language-server vscode-langservers-extracted prettier neovim
# paru -S --noconfirm nvm

# java/scala
# sudo pacman -S --noconfirm jdk-openjdk maven sbt
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
# pip install pynvim pyright black ruff debugpy sqlfluff dvc dvc-gdrive ansible --upgrade

# install machine learning/data science (mlds) environment
# conda create -n mlds python=3.10
# pip install numpy scipy cython numba pandas matplotlib seaborn scikit-learn xgboost catboost lightgbm statsmodels treelite treelite_runtime polars jupyterlab pyspark "dask[complete]" --upgrade
# pip install torch torchvision pytorch-lightning transformers gym optuna mlflow wandb triton taichi --upgrade
# pip install --upgrade "jax[cuda]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
# pip install opencv-python opencv-contrib-python --upgrade

# latex
# sudo pacman -S --noconfirm texlive-core texlive-latexextra texlive-bibtexextra biber texlive-science texlab
# TODO: fix tlmgr.pl
# sudo sed -i -e "s/\$Master\/..\/../\$Master\/..\/..\/../g" /usr/share/texmf-dist/scripts/texlive/tlmgr.pl
# tlmgr init-usertree
# tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
# tlmgr install libertine
# tlmgr install doublestroke

# docker, k3s, ...
# sudo pacman -S --noconfirm docker docker-compose kubectl helm skaffold nfs-utils
# paru -S --noconfirm nvidia-container-runtime nvidia-container-toolkit
# sudo usermod -aG docker $USER
# curl -sfL https://get.k3s.io | sh -

# install zsh shell -----------------------------------
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions && \
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
git clone https://github.com/romkatv/powerlevel10k ~/.oh-my-zsh/custom/themes/powerlevel10k && \
rm -f ~/.zshrc

# install doomemacs
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d && \
rm -rf ~/.doom.d

# link configs ----------------------------------------
cd ~
git clone git@github.com:txdat/dotfiles .dotfiles
# git clone https://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@github.com/txdat/dotfiles .dotfiles
cd .dotfiles

# k3s
sudo mkdir -p /etc/docker && sudo ln -s ~/.dotfiles/k3s/docker/daemon.json /etc/docker/daemon.json
sudo mkdir -p /etc/containerd && sudo ln -s ~/.dotfiles/k3s/containerd/config.toml /etc/containerd/config.toml

# install fonts
sudo cp -r fonts/jetbrains /usr/share/fonts && sudo fc-cache -vfs

# fix emoji displaying
sudo ln -s 75-noto-color-emoji.conf /usr/share/fontconfig/conf.avail/75-noto-color-emoji.conf && \
sudo ln -s 75-noto-color-emoji.conf /etc/fonts/conf.d/75-noto-color-emoji.conf

# jupyterlab
mkdir -p ~/.jupyter/lab/user-settings && \
ln -s ~/.dotfiles/.jupyter/lab/user-settings/@jupyterlab ~/.jupyter/lab/user-settings/@jupyterlab

# link config
./link_config.sh

# finish installing ----------------------------------
cd ~
neofetch
