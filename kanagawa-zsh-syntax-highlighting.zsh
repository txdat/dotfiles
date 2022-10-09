# Kanagawa Theme (for zsh-syntax-highlighting)
#
# Paste this files contents inside your ~/.zshrc before you activate zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES

# Main highlighter styling: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
#
## General
### Diffs
### Markup
## Classes
## Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=#54546d'
## Constants
## Entitites
## Functions/methods
ZSH_HIGHLIGHT_STYLES[alias]='fg=#76946a'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#76946a'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#76946a'
ZSH_HIGHLIGHT_STYLES[function]='fg=#76946a'
ZSH_HIGHLIGHT_STYLES[command]='fg=#76946a'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#76946a,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#ffa066,italic'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#ffa066'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#ffa066'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#957fb8'
## Keywords
## Built ins
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#76946a'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#76946a'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#76946a'
## Punctuation
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#d27e99'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#dcd7ba'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#dcd7ba'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#dcd7ba'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#d27e99'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#d27e99'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#d27e99'
## Serializable / Configuration Languages
## Storage
## Strings
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#c0a36e'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#c0a36e'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#c0a36e'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#c34043'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#c0a36e'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#c34043'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#c0a36e'
## Variables
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#dcd7ba'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#c34043'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#dcd7ba'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#dcd7ba'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#dcd7ba'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#dcd7ba'
## No category relevant in spec
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#c34043'
ZSH_HIGHLIGHT_STYLES[path]='fg=#dcd7ba,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#d27e99,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#dcd7ba,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#d27e99,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#dcd7ba'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#957fb8'
#ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
#ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
#ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#c34043'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#dcd7ba'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#dcd7ba'
ZSH_HIGHLIGHT_STYLES[default]='fg=#dcd7ba'
ZSH_HIGHLIGHT_STYLES[cursor]='fg=#dcd7ba'
