# --------------------------------------------------
# shellcheck shell=zsh
# --------------------------------------------------

# --------------------------------------------------
# check for env being disabled
# --------------------------------------------------
[ -f $HOME/.noenv ] && return

# --------------------------------------------------
# simple tracing 
# --------------------------------------------------
# source() { echo $SHELL sourcing: $1; builtin source $1; }
# .() { echo $SHELL sourcing: $1; builtin source $1; }

# --------------------------------------------------
# more exhaustive tracing - also see block at bottom
# --------------------------------------------------
# zmodload zsh/zprof
# PS4=$'\\\011%D{%s%6.}\011%x\011%I\011%N\011%e\011'
# exec 3>&2 2> $HOME/zshstart.$$.log
# setopt xtrace prompt_subst

# --------------------------------------------------
# call ~/.globalrc early
# --------------------------------------------------
[ -f $HOME/.globalrc ] && source $HOME/.globalrc

# --------------------------------------------------
# shell options
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
PERIOD=300
PS1=$'%{\e[0;32m%}%n@%m:%{\e[1;33m%}%2c%#%{\e[0m%} '
PS4=$'%{\e[0;33m%}+%x:%I>%{\e[0m%} '
READNULLCMD=$PAGER
TMPPREFIX=$XDG_RUNTIME_DIR/tmp/zsh
export PERIOD SHELL

# --------------------------------------------------
# non-env variables
# --------------------------------------------------
#context='%{\e[0;32m%}%n@%m'   # becomes part of prompt
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
bindkey '^[OA'  up-line-or-beginning-search
bindkey '^[OB'  down-line-or-beginning-search
bindkey '^[[A'  up-line-or-beginning-search
bindkey '^[[B'  down-line-or-beginning-search

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search up-line-or-beginning-search
zle -N down-line-or-beginning-search down-line-or-beginning-search

# --------------------------------------------------
# alias(es)
# --------------------------------------------------
alias compinit='compinit -C -d $XDG_RUNTIME_DIR/zsh/zcompdump'

# --------------------------------------------------
# functions
# --------------------------------------------------
..() { builtin cd ..; }
s()  { savehist; sudo -sE HOME=$HOME ; readhist; }

# ------------------------------------------------------------
# VCS aware prompt
# ------------------------------------------------------------
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' actionformats '|%F{2}%b%f|%F{1}%a'
zstyle ':vcs_info:*' formats       '|%F{2}%b'
precmd() { vcs_info; header; }

# --------------------------------------------------
# right-side prompt
# --------------------------------------------------
RPROMPT='%F{green}${SUBENV}${vcs_info_msg_0_}%f'; [ "$TMUX" ] && RPROMPT=''
autoload -U colors; colors
# kubectl config current-context > /dev/null 2>&1 && \
# RPROMPT='${vcs_info_msg_0_}[%{$fg[green]%}$(kubectl config current-context)%{$reset_color%}]'

# --------------------------------------------------
# root specific tweaks
# --------------------------------------------------
[ "$EUID" = 0 ] && { 
  \u\mask \2\2; 
  PS1=$'%{\e[0;31m%}%n@%m:%{\e[1;33m%}%2c%#%{\e[0m%} '; 
  sudo() {$@;};
}

setopt nullglob
for f in $LPROFILES/{,$SUBENV}/.early/*.{,z}sh ; source $f
for f in $PROFILES/*.{,z}sh; source $f
for f in $LPROFILES/{,$SUBENV}/{,.late}/*.{,z}sh ; source $f
setopt nonullglob
unset f

# ----------------------------------------------------------------------
# from: http://hintsforums.macworld.com/archive/index.php/t-6493.html
# ----------------------------------------------------------------------
## case-insensitive (uppercase from lowercase) completion
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## case-insensitive (all) completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
## case-insensitive,partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $XDG_RUNTIME_DIR/zsh/zcompcache

# add colors to completions
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# complete cd with local dirs if a match, then path dirs
zstyle ':completion:*:cd:*' tag-order local-directories path-directories

# help tmux find custom sockets dir
zstyle ':completion:*:*:tmux:*:sockets' socketdir "${TMUX_TMPDIR}/tmux-${UID}"

# ----------------------------------------
# account completion via defined config
# ----------------------------------------
my_accounts=({root,centos,ubuntu,ec2-user}@rhel8)
[ -f $XDG_CONFIG_HOME/enum/hosts ]    && hosts=($(cat $XDG_CONFIG_HOME/enum/hosts)) || hosts=()
[ -f $XDG_CONFIG_HOME/enum/domains ]  && domains=($(cat $XDG_CONFIG_HOME/enum/domains)) || domains=()
[ -f $XDG_CONFIG_HOME/enum/users ] && users=($(cat $XDG_CONFIG_HOME/enum/users)) || users=()
accounts_spec=($(echo $users | tr -s ' ' ','))
# my_accounts=($my_accounts $(eval echo $accounts_spec))
my_accounts=($my_accounts $users)
# for h in $hosts ; do
#   my_accounts=($my_accounts $(eval echo ${accounts_spec}@$h))
#   for d in $domains ; do
#     my_accounts=($my_accounts $(eval echo ${accounts_spec}@$h.$d))
#   done
# done
# unset d h accounts_spec

# --------------------------------------------------
# this must occur after defining 'my_accounts'
# --------------------------------------------------
zstyle ':completion:*:my-accounts' users $my_accounts
zstyle ':completion:*:my-accounts' users-hosts $my_accounts 

# ----------------------------------------
# hostname completion via known_hosts
# ----------------------------------------
[ -r ~/.ssh/known_hosts ] && myhosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || myhosts=()
zstyle -e ':completion:*:hosts' hosts 'reply=($myhosts)'

declare -a fplist
fplist=( /usr/local/share/zsh-completions $XDG_RUNTIME_DIR/zsh/functions ~/.files/zsh.d/functions )
for d in $fplist; { [ -d "$d" ] && fpath=($d $fpath); }
unset d fplist

# ------------------------------
# fallback completion for aws
# ------------------------------
[ "${functions[aws]}" ] && {
  declare -a aws_completer_scripts
  aws_completer_scripts=( "${commands[aws]%%aws}aws_zsh_completer.sh" /usr/local/share/zsh/site-functions/aws_zsh_completer.sh /usr/bin/aws_zsh_completer.sh )
  for f in ${aws_completer_scripts[@]}; { [ -f $f ] && source $f && break; }		# first match wins
  unset f aws_completer_scripts
}

profile_dirs=($PROFILES $LPROFILES)
compctl -g '*' -W /etc/init.d start status stop restart
compctl -k "(all rhel7 rhel8)" -x 'p[2]' -f -- dist2
compctl -g '*' -W $XDG_CONFIG_HOME/myconfig myconfig
compctl -W profile_dirs -/ getenv
autoload -U compinit
autoload -U +X bashcompinit && bashcompinit
compinit
compdef _vars e
complete -o nospace -C /usr/local/bin/terraform terraform

# ------------------------------------------------------------------------------------------
_pssh() { _arguments : '-h+:hosts:( ~/.local/pssh-hosts/*(DN) )' '*: : _default' ;}
compdef _pssh pssh pscp
compdef _path_commands h hh hhh
# ------------------------------------------------------------------------------------------

# --------------------
# remove dupes
# --------------------
typeset -U path cdpath manpath fpath 

# ----------------------------------------------------------------------
# disable exhaustive tracing - this is paired with section at the top
# ----------------------------------------------------------------------
# unsetopt xtrace
# exec 2>&3 3>&-
# zprof            # for profiling

# --------------------
# muxrc
# --------------------
[ -f ~/.muxrc ] && source ~/.muxrc
[ "$TERM" =~ tmux ] && [ ! -f /usr/share/terminfo/*/$TERM ] && TERM=screen-256color         # tmux v1.x hack

