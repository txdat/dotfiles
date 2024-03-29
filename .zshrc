# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# completion
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey '^I'   complete-word       # tab          | complete
bindkey '^[[Z' autosuggest-accept  # shift + tab  | autosuggest
bindkey -v '^?' backward-delete-char

# syntax highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# prompt
source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # run 'p10k configure'

# fzf
# export FZF_DEFAULT_COMMAND="rg --hidden --color=always --no-heading --with-filename --line-number --column --smart-case --max-columns=4096 ''"
export FZF_DEFAULT_OPTS="
 --ansi --multi --no-separator
 --scrollbar='' --info=inline --height=100%
 --layout=reverse --border=none --pointer=󰁕 --marker=▶
 --preview-window=hidden:noborder
 --bind=ctrl-p:toggle-preview,alt-p:toggle-preview-wrap
 --bind=alt-j:preview-page-down,alt-k:preview-page-up
"

alias fzfp="fzf --preview 'bat --color=always {}'" # fzf with bat preview

# conda
CONDA_HOME="$HOME/.miniconda"

if [[ -n "$CONDA_HOME" ]]; then
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
fi

# emacs
#export PATH="$HOME/.emacs.d/bin:$PATH"

# rust
export PATH="$HOME/.cargo/env:$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin:$PATH"

# go
export PATH="$HOME/go/bin:$PATH"

# haskell
#export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"

# java/scala
#export JAVA_HOME='/usr/lib/jvm/default'
#export PATH=$JAVA_HOME/bin:$PATH
#export PATH=$HOME/.local/share/coursier/bin:$PATH

# javascript
# source /usr/share/nvm/init-nvm.sh

# kubernetes (k3s)
export KUBECONFIG=$HOME/.kube/config
#export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# aliases
#alias syyu="sudo pacman -Syyu && paru -Syyu"

alias x2cb="xclip -sel c" # copy output to clipboard
alias f2cb="xclip -sel c < " # copy from file to clipboard
alias cb2f="xclip -sel c -o > " # copy from clipboard to file

#alias tlmgr="/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode"

alias k=kubectl

# extend_display () {
#     direction="${1:-same-as}"
#     display="${2:-DisplayPort-0}"
#     width="${3:-1920}"
#     display0="${4:-eDP}"
#     width0="${5:-3072}"
#     scale=$(echo "scale=5;$width0/$width" | bc)
#
#     if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
#         # TODO: wayland
#     else
#         # x11
#         xrandr --output $display --scale 2x2 && xrandr --output $display --$direction $display0 --scale ${scale}x${scale} --auto
#     fi
# }
#
# set_primary_display () {
#     display="${1:-DisplayPort-0}"
#     width="${2:-1920}"
#     scale=$(echo "scale=5;3072/$width" | bc)
#
#     if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
#         # TODO: wayland
#     else
#         # x11
#         xrandr --output $display --scale 2x2 && xrandr --output eDP --off --output $display --scale ${scale}x${scale} --auto --primary
#     fi
# }

#start_k3s () {
#    # add kube-system's dns to resolv
#    # dns=$(echo $(kubectl get svc -n kube-system | grep dns) | awk '{ print $3 }')
#    # sudo sed -i "1s/^/nameserver ${dns} #k3s\n/" /etc/resolv.conf
#
#    KUBE_SERVICES=(
#        # 'docker.socket'
#        # 'docker.service'
#        'containerd.service'
#        # 'nfs-server.service'
#        'k3s.service'
#    )
#    for svc in "${KUBE_SERVICES[@]}"
#    do
#        sudo systemctl start $svc
#    done
#}
#
#stop_k3s () {
#    # remove kube-system's dns in resolv
#    # sudo sed -i "/#k3s$/d" /etc/resolv.conf
#
#    KUBE_SERVICES=(
#        # 'docker.socket'
#        # 'docker.service'
#        'containerd.service'
#        # 'nfs-server.service'
#        'k3s.service'
#    )
#    for svc in "${KUBE_SERVICES[@]}"
#    do
#        sudo systemctl stop $svc
#    done
#}

# update zsh and plugins
update_zsh () {
    dir=$(pwd)

    ZSH_PLUGINS=('powerlevel10k' 'zsh-syntax-highlighting' 'zsh-autosuggestions')
    for plg in "${ZSH_PLUGINS[@]}"
    do
        cd ~/.zsh/$plg && git pull
    done

    cd $dir
}
