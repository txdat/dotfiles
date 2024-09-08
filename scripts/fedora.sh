#!/bin/sh

# remove bloatwares
sudo dnf remove -y kmines akregator kmail krdc krfb neochat dragon kaddressbook korganizer mediawriter konversation elisa-player filelight kamoso kcalc kde-partitionmanager kfind kcharselect kmahjongg kmouth kgpg kmousetool kpat skanpage kolourpaint

sudo dnf update -y

# install rpmfusion
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf group update core -y

# update media codecs
sudo dnf swap 'ffmpeg-free' 'ffmpeg'
sudo dnf swap 'ffmpeg-free' 'ffmpeg' --allowerasing
sudo dnf group install Multimedia -y
sudo dnf install -y ffmpeg ffmpeg-libs libva libva-utils
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

# base packages
sudo dnf copr enable atim/lazygit -y
sudo dnf install -y axel git lazygit git-delta difftastic zsh tmux ranger openssh xclip fzf ripgrep fd-find jq bat vim neovim alacritty chromium zathura zathura-pdf-mupdf mpv fcitx5 fcitx5-configtool fcitx5-qt fcitx5-gtk fcitx5-unikey

# flatpak applications
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub net.ankiweb.Anki
flatpak install flathub com.dropbox.Client
flatpak install flathub com.spotify.Client
flatpak install flathub com.calibre_ebook.calibre
flatpak install flathub md.obsidian.Obsidian

# zsh
mkdir -p .zsh && \
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting && \
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions && \
git clone --depth=1 https://github.com/zsh-users/zsh-completions ~/.zsh/zsh-completions && \
chsh -s $(which zsh)

# c/c++
# sudo dnf install -y gcc gcc-c++ gdb make cmake ccache valgrind strace clang llvm lldb lld clang-tools-extra openblas openmpi lapack eigen3-devel boost

# javascript, typescript
# curl -fsSL https://fnm.vercel.app/install | bash
# fnm use --install-if-missing 20
# npm install -g typescript typescript-language-server vscode-langservers-extracted prettier @fsouza/prettierd neovim demergi

# python
# axel -n 8 https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
# chmod a+x ./Miniconda3-latest-Linux-x86_64.sh
# ./Miniconda3-latest-Linux-x86_64.sh
# rm -f ./Miniconda3-latest-Linux-x86_64.sh
# conda update --all -y
# conda config --set auto_activate_base false
# pip install pynvim pyright black ansible awscli --upgrade

# docker
# sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
# sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose
# sudo usermod -aG docker $USER

# k8s
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# rm -f kubectl
# sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
# sudo dnf install -y helm terraform
