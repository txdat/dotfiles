# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ------------------
# config
# ------------------

#export TERM="xterm-256color"
export EDITOR="vim"

# history
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

# completion
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

# ------------------
# plugins
# ------------------

# completion
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey '^I'   complete-word       # tab          | complete
bindkey '^[[Z' autosuggest-accept  # shift + tab  | autosuggest

# syntax highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# prompt
source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # run 'p10k configure'

# ------------------
# user's config
# ------------------

# fzf
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

# conda
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

# emacs
# export PATH="$HOME/.emacs.d/bin:$PATH"

# rust
export PATH="$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin:$PATH"

# haskell
# export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"

# java/scala
export JAVA_HOME='/usr/lib/jvm/default'
export PATH=$JAVA_HOME/bin:$PATH
export PATH=$HOME/.local/share/coursier/bin:$PATH

# javascript
# source /usr/share/nvm/init-nvm.sh

# custom aliases
alias syyu="sudo pacman -Syyu && paru -Syyu"

alias x2cb="xclip -sel c" # copy output to clipboard
alias f2cb="xclip -sel c < " # copy from file to clipboard
alias cb2f="xclip -sel c -o > " # copy from clipboard to file

alias tlmgr="/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode"

# display projecting
extend_display () {
    display="${1:-DisplayPort-0}"
    width="${2:-1920}"
    direction="${3:-right-of}"
    display0="${4:-eDP}"
    width0="${5:-3072}"
    scale=$(echo "scale=5;$width0/$width" | bc)
    xrandr --output $display --scale 2x2 && xrandr --output $display --scale ${scale}x${scale} --$direction $display0 && xrandr --output $display0 --scale 0.9999x0.9999 && xrandr --output $display --set TearFree on
}

set_primary_display () {
    display="${1:-DisplayPort-0}"
    width="${2:-1920}"
    display0="${3:-eDP}"
    width0="${4:-3072}"
    scale=$(echo "scale=5;$width0/$width" | bc)
    xrandr --output $display --scale 2x2 && xrandr --output $display --scale ${scale}x${scale} --set TearFree on
}

# kubernetes (k3s)
export KUBECONFIG=$HOME/.kube/config

start_kube () {
    # add kube-system's dns to resolv
    sudo sed -i "1s/^/nameserver ${1:-10.43.0.10} # kube\n/" /etc/resolv.conf  # run 'kubectl get svc -n kube-system | grep dns'

    KUBE_SERVICES=('docker.socket' 'docker.service' 'containerd.service' 'nfs-server.service' 'k3s.service')
    for svc in "${KUBE_SERVICES[@]}"
    do
        sudo systemctl start $svc
    done
}

stop_kube () {
    # remove kube-system's dns in resolv
    sudo sed -i "/kube$/d" /etc/resolv.conf

    KUBE_SERVICES=('docker.socket' 'docker.service' 'containerd.service' 'nfs-server.service' 'k3s.service')
    for svc in "${KUBE_SERVICES[@]}"
    do
        sudo systemctl stop $svc
    done
}

# update zsh and plugins
update_zsh () {
    ZSH_PLUGINS=('powerlevel10k' 'zsh-syntax-highlighting' 'zsh-autosuggestions')
    for plg in "${ZSH_PLUGINS[@]}"
    do
        cd ~/.zsh/$plg && git pull
    done

    cd ~
}
