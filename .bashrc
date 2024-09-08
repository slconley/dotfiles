# shellcheck shell=bash

# --------------------------------------------------
# good for debugging (use "set -x")
# --------------------------------------------------
# source() { echo $SHELL sourcing: $1; builtin source $1; }
# export PS4='\[\e[0;33m\][${BASH_SOURCE[0]:-inherited}:${LINENO}:${FUNCNAME[0]:-main}]>>>\[\e[0m\] '

# --------------------------------------------------
# globalrc should always be first
# --------------------------------------------------
[ -f $HOME/.globalrc ] && source $HOME/.globalrc

# --------------------------------------------------
# remainder is specific to interactive shells
# --------------------------------------------------
[ "$PS1" ] || return

# --------------------------------------------------
# completion
# --------------------------------------------------
complete -A directory cd 2> /dev/null
complete -C /usr/local/bin/terraform terraform
[[ -d /etc/init.d ]] && complete -W "$(command ls /etc/init.d/)" service stop start restart status 2> /dev/null
[[ -d ~/.local/pssh-hosts ]] && complete -W "$(command ls ~/.local/pssh-hosts)" pssh 2> /dev/null
for f in /etc/profile.d/bash_completion.sh /usr/local/etc/bash_completion.d/pass; do 
  [ -f "$f" ] && source "$f"
done 

# --------------------------------------------------
# key bindings
# --------------------------------------------------
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
bind '"\C-?":kill-whole-line'
bind 'set completion-ignore-case on'

# --------------------------------------------------
# misc
# --------------------------------------------------
export BASH_SILENCE_DEPRECATION_WARNING=1
savehist() { history -a; }

shopt -s nullglob
for f in $LPROFILES/.early/*.{,ba}sh ; do source $f; done
for f in $LPROFILES/$SUBENV/.early/*.{,ba}sh ; do source $f; done
for f in $PROFILES/*.{,ba}sh $PROFILES/.profile.${OSNAME}*; do source $f; done
for f in $PROFILES/$SUBENV/*.{,ba}sh ; do source $f; done
for f in $LPROFILES/{,.late}/*.{,ba}sh ; do source $f; done
for f in $LPROFILES/$SUBENV/{,.late}/*.{,ba}sh ; do source $f; done
shopt -u nullglob
                                                                                                                                            # --------------------------------------------------
# env var(s)
# --------------------------------------------------
HISTFILE="$HISTDIR/bash.histfile.${HIST_DTG}"
PS1='\[\e[0;32m\][\u@\h:\w]\$\[\e[0m\] '
PROMPT_DIRTRIM=2
export PROMPT_DIRTRIM HISTFILE
touch $HISTFILE 2> /dev/null || HISTFILE="$(eval cd ~$USER && pwd)/${NICK}/bash.histfile.${HIST_DTG}"

# --------------------------------------------------
# ensure "python" maps to somethingg (v3 preferred)
# --------------------------------------------------
# hash -p $(type -p python3 2> /dev/null) python > /dev/null 2>&1
# type -p python >/dev/null 2>&1 || hash -p $(type -p python2 2> /dev/null) python > /dev/null 2>&1

# --------------------------------------------------
# root specific tweak(s)
# --------------------------------------------------
[ "$EUID" = 0 ] && { umask \2\2; PS1='\[\e[0;31m\][\u@\h:\w]\$\[\e[0m\] '; }

# --------------------------------------------------
# muxrc
# --------------------------------------------------
[ -f ~/.muxrc ] && source ~/.muxrc
[[ "$TERM" =~ tmux && ! -f /usr/share/terminfo/t/$TERM ]] && TERM=screen-256color         # tmux v1.x hack

# vi: filetype=bash
