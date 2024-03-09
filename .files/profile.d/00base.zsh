# shellcheck shell=sh

# --------------------------------------------------
# options
# --------------------------------------------------
setopt auto_cd
setopt auto_pushd
setopt chase_links
setopt magic_equal_subst
setopt no_beep
setopt no_nomatch
setopt notify
setopt pushd_silent
setopt pushd_silent
setopt rm_star_silent
setopt transient_rprompt

unset zle_bracketed_paste

# --------------------------------------------------
# environment variables
# --------------------------------------------------
DIRSTACKSIZE=20
PERIOD=600
PS1=$'%{\e[0;32m%}%n@%m:%{\e[1;33m%}%2c %#%{\e[0m%} '
PS4=$'%{\e[0;33m%}+%x:%I>%{\e[0m%} '
export PERIOD SHELL

# --------------------------------------------------
# non-env variables
# --------------------------------------------------
#context='%{\e[0;32m%}%n@%m'   # becomes part of prompt
my_accounts=({root,centos,ubuntu,ec2-user}@{kali})
watch=notme

# --------------------------------------------------
# key bindings
# --------------------------------------------------
bindkey -e                          # always choose emacs/vi before other settings
bindkey -s "^[OM" "^M"              # KP <enter> needs help in random places
bindkey '\e[3~' kill-whole-line     # if <del> fails, gen with echo '<ctrl>v,<del>'
bindkey '^b'    backward-word
bindkey '^e'    vi-forward-blank-word-end
bindkey '^f'    forward-word
bindkey '^w'    forward-word
bindkey '\e[1~' beginning-of-line   # home key
bindkey '\e[4~' end-of-line         # end key

# --------------------------------------------------
# key bindings
# --------------------------------------------------
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search up-line-or-beginning-search
zle -N down-line-or-beginning-search down-line-or-beginning-search
bindkey '^[OA'    up-line-or-beginning-search
bindkey '^[OB'    down-line-or-beginning-search
bindkey '^[[A'    up-line-or-beginning-search
bindkey '^[[B'    down-line-or-beginning-search

# --------------------------------------------------
# functions
# --------------------------------------------------
..()       { builtin cd ..; }
s()        { savehist; sudo -sE HOME=$HOME ; readhist; }

# ----------------------------------------------------------------------
# from: http://hintsforums.macworld.com/archive/index.php/t-6493.html
# ----------------------------------------------------------------------
## case-insensitive (uppercase from lowercase) completion
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## case-insensitive (all) completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
## case-insensitive,partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

## completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.local/.zsh/$HOST/zcompcache

## add colors to completions
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# complete cd with local dirs if a match, then path dirs
zstyle ':completion:*:cd:*' tag-order local-directories path-directories

# completion for commands that use usernames/hostnames (i.e. ssh)
zstyle ':completion:*:my-accounts' users-hosts $my_accounts

# ------------------------------------------------------------
# VCS aware prompt
# ------------------------------------------------------------
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' actionformats '%F{5}|%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       '%F{3}|%F{2}%b%F{3}|%f'
precmd() { vcs_info; header; }
PS1=$'%{\e[0;32m%}%n@%m:%{\e[1;33m%}%2c%#%{\e[0m%} '

# RPROMPT
RPROMPT='${vcs_info_msg_0_}'
autoload -U colors; colors
# kubectl config current-context > /dev/null 2>&1 && \
# RPROMPT='${vcs_info_msg_0_}[%{$fg[green]%}$(kubectl config current-context)%{$reset_color%}]'

# --------------------------------------------------
# root specific tweaks
# --------------------------------------------------
[ "$me" = "root" ] && { umask 22; PS1=$'%{\e[0;31m%}%n@%m:%{\e[1;33m%}%2c%#%{\e[0m%} '; }

# vi: ft=sh
