#!/bin/sh

# install base packages ---------------------------------------
sudo pacman -S --noconfirm curl wget axel rsync \
                           git lazygit git-delta \
                           zsh tmux htop ranger neofetch \
                           vim neovim \
                           # emacs-nativecomp \
                           zip unzip p7zip ark \
                           bat man \
                           xclip xdotool fzf fzy ripgrep fd \
                           openssh \
                           pacman-contrib nvidia \
                           # qemu-full \
                           # flatpak \

sudo pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

# enable essential services ----------------------------------
sudo systemctl enable sshd.service
sudo systemctl enable fstrim.timer
sudo systemctl enable paccache.timer

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
if [ $(cat /etc/hostname) == "yoga14" ]
then
# set sddm high dpi
sudo mkdir -p /etc/sddm.conf.d
sudo tee -a /etc/sddm.conf.d/dpi.conf > /dev/null <<EOL
[X11]
ServerArguments=-nolisten tcp -dpi 160
EOL

sudo pacman -S --noconfirm amd-ucode tlp tlp-rdw

# enable tlp service
sudo tee -a /etc/tlp.conf > /dev/null <<EOL
START_CHARGE_THRESH_BAT0=0  # dummy value
STOP_CHARGE_THRESH_BAT0=1

NATACPI_ENABLE=1
TPACPI_ENABLE=1
TPSMAPI_ENABLE=1
EOL

sudo systemctl enable tlp.service
fi # end of "yoga14"

# install paru -------------------------------------------
sudo pacman -S --noconfirm rustup

# install rust toolchain
rustup toolchain install stable && rustup default stable

# compile paru
git clone https://aur.archlinux.org/paru .paru && cd .paru/ && makepkg -si && cd -

# install essential applications ------------------------
sudo pacman -S --noconfirm dolphin \
                           alacritty \
                           firefox \
                           chromium \
                           gwenview mpv spectacle \
                           zathura zathura-pdf-mupdf \
                           zenity ffmpeg4.4 \
                           calibre \
                           obsidian \
                           dbeaver

paru -S --noconfirm ibus-bamboo \
                    dropbox \
                    spotify \
                    visual-studio-code-bin \
                    sioyek \
                    anki

# git config --------------------------------------------
git config --global user.name "txdat" && \
git config --global user.email "dattranx105@gmail.com" && \
ssh-keygen

# install essential development packages ----------------
sudo pacman -S --noconfirm gcc gcc-fortran gdb \
                           clang llvm lldb lld \
                           make cmake ccache ctags valgrind strace \
                           python python-pip \
                           nodejs npm \
                           go gopls

sudo pacman -S --noconfirm blas cblas openblas \
                           openmp openmpi \
                           lapack lapacke eigen tbb \
                           boost \
                           ffmpeg4.4 libuv \
                           gperftools gflags google-glog gtest protobuf \
                           cuda cudnn magma nccl nvidia-utils \
                           opencv-cuda \
                           vulkan-icd-loader \
                           vulkan-radeon amdvlk \
                           # vulkan-intel \

# docker, k3s, ...
sudo pacman -S --noconfirm docker docker-compose kubectl helm skaffold nfs-utils
paru -S --noconfirm nvidia-container-runtime nvidia-container-toolkit
sudo usermod -aG docker $USER

# rust
rustup component add rust-src
rustup component add rust-analyzer

# javascript/typescript
sudo npm install -g typescript typescript-language-server eslint prettier prettier-eslint prettier-eslint-cli
curl -fsSL https://deno.land/install.sh | sh

# haskell
# paru -S --noconfirm ghcup-hs-bin
# ghcup install ghc && ghcup install cabal && ghcup install hls

# python
axel -n 16 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
chmod a+x ./Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh
rm -f ./Miniconda3-latest-Linux-x86_64.sh
~/miniconda3/bin/conda update --all -y
~/miniconda3/bin/pip install pynvim pyright black ruff dvc dvc-gdrive ansible debugpy sqlfluff jupyterlab --upgrade

# important python packages
# ~/miniconda3/bin/pip install numpy scipy cython numba pandas matplotlib seaborn scikit-learn xgboost catboost lightgbm statsmodels treelite treelite_runtime polars pyspark "dask[complete]" --upgrade
# ~/miniconda3/bin/pip install torch torchvision pytorch-lightning transformers gym optuna mlflow wandb triton taichi --upgrade
# ~/miniconda3/bin/pip install pyg-lib torch-scatter torch-sparse torch-cluster torch-spline-conv torch-geometric -f https://data.pyg.org/whl/torch-1.13.0+cu117.html --upgrade
# ~/miniconda3/bin/pip install --upgrade "jax[cuda]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
# ~/miniconda3/bin/pip install dm-haiku flax optax rlax trax --upgrade
# ~/miniconda3/bin/pip install opencv-python opencv-contrib-python --upgrade

# latex
sudo pacman -S --noconfirm texlive-core texlive-latexextra texlive-bibtexextra biber texlive-science texlab
# TODO: fix tlmgr.pl
sudo sed -i -e "s/\$Master\/..\/../\$Master\/..\/..\/../g" /usr/share/texmf-dist/scripts/texlive/tlmgr.pl
/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode init-usertree
/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode install libertine
/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode install doublestroke

# install zsh shell -----------------------------------
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions && \
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
git clone https://github.com/romkatv/powerlevel10k ~/.oh-my-zsh/custom/themes/powerlevel10k && \
rm -f ~/.zshrc

# install doomemacs
# git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.emacs.d && \
# ~/.emacs.d/bin/doom install

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

# fix displaying emoji
sudo cp 75-noto-color-emoji.conf /usr/share/fontconfig/conf.avail && \
sudo ln -s /usr/share/fontconfig/conf.avail/75-noto-color-emoji.conf /etc/fonts/conf.d/75-noto-color-emoji.conf

# jupyterlab
mkdir -p ~/.jupyter/lab/user-settings && \
ln -s ~/.dotfiles/.jupyter/lab/user-settings/@jupyterlab ~/.jupyter/lab/user-settings/@jupyterlab

# link config
./link_config.sh

# config bat
bat cache --build

cd -

# finish installing ----------------------------------
neofetch
