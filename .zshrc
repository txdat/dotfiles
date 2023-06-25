# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker docker-compose kubectl zsh-autosuggestions zsh-syntax-highlighting)

fpath+=$ZSH/custom/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#export TERM="xterm-256color"

# export FZF_DEFAULT_COMMAND="rg --hidden --color=always --no-heading --with-filename --line-number --column --smart-case --max-columns=4096 ''"
export FZF_DEFAULT_OPTS="
 --ansi --multi --no-separator
 --scrollbar='' --info=inline --height=100%
 --layout=reverse --border=none --pointer= --marker=▶
 --preview-window=hidden:noborder
 --bind=ctrl-p:toggle-preview,alt-p:toggle-preview-wrap
 --bind=alt-j:preview-page-down,alt-k:preview-page-up
"

alias fzfp="fzf --preview 'bat --color=always {}'" # fzf with bat preview

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
CONDA_HOME="$HOME/.miniconda"

__conda_setup="$('$CONDA_HOME/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$CONDA_HOME/etc/profile.d/conda.sh" ]; then
        . "$CONDA_HOME/etc/profile.d/conda.sh"
    else
        export PATH="$CONDA_HOME/bin:$PATH"
    fi
fi
unset __conda_setup

export PATH="$CONDA_HOME/bin:$PATH"
# <<< conda initialize <<<

export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin:$PATH"
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"

export JAVA_HOME='/usr/lib/jvm/default'
export PATH=$JAVA_HOME/bin:$PATH
export PATH=$HOME/.local/share/coursier/bin:$PATH

# nodejs
#source /usr/share/nvm/init-nvm.sh

# flutter development
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export PATH=$HOME/flutter/bin:$HOME/.pub-cache/bin:$PATH
export PATH=$ANDROID_SDK_ROOT/platform-tools:$PATH
export PATH=$ANDROID_SDK_ROOT/tools/bin:$PATH
export PATH=$ANDROID_SDK_ROOT/tools:$PATH
export PATH=$ANDROID_SDK_ROOT/emulator:$PATH
export CHROME_EXECUTABLE=$(which chromium)

# custom aliases
alias syyu="sudo pacman -Syyu && paru -Syyu"

alias ficp="xclip -sel c < " # copy from file to clipboard
alias fipt="xclip -sel c -o > " # copy from clipboard to file
alias cpcb="xclip -sel c" # copy output to clipboard

alias tlmgr="/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode"

# setup external fullhd display to the right
alias xfhdr="xrandr --output DisplayPort-0 --scale 2x2 && xrandr --output DisplayPort-0 --scale 1.6x1.6 --right-of eDP && xrandr --output eDP --scale 0.9999x0.9999 && xrandr --output DisplayPort-0 --set TearFree on"

# kubernetes (k3s)
export KUBECONFIG=$HOME/.kube/config

start_kube () {
    # add kube-system's dns to resolv
    sudo sed -i "1s/^/nameserver ${1:-10.43.0.10} # kube\n/" /etc/resolv.conf  # run 'kubectl get svc -n kube-system | grep dns'

    KUBE_SERVICES=('docker.socket' 'docker.service' 'containerd.service' 'nfs-server.service' 'k3s.service')
    for svc in "${KUBE_SERVICES[@]}"
    do
        echo starting $svc
        sudo systemctl start $svc
    done
}

stop_kube () {
    # remove kube-system's dns in resolv
    sudo sed -i "/kube$/d" /etc/resolv.conf

    KUBE_SERVICES=('docker.socket' 'docker.service' 'containerd.service' 'nfs-server.service' 'k3s.service')
    for svc in "${KUBE_SERVICES[@]}"
    do
        echo stopping $svc
        sudo systemctl stop $svc
    done
}

# update zsh and plugins
update_zsh () {
    omz update

    cd ~/.oh-my-zsh/custom/themes/powerlevel10k && echo updating powerlevel10k && git pull

    ZSH_PLUGINS=('zsh-completions' 'zsh-syntax-highlighting' 'zsh-autosuggestions')
    for plg in "${ZSH_PLUGINS[@]}"
    do
        cd ~/.oh-my-zsh/custom/plugins/$plg && echo updating $plg && git pull
    done

    cd ~
}
