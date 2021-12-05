# shellcheck shell=bash

# --------------------------------------------------
# only for interactive sessions
# --------------------------------------------------
[ "$PS1" ] || return

# --------------------------------------------------
# env vars
# --------------------------------------------------
HISTFILE="$HOME/.var/history/$HOST/bash.${HIST_DTG}"
PS1='\[\e[0;32m\][\u@\h \W]\$\[\e[0m\] '
PROMPT_DIRTRIM=2
export PROMPT_DIRTRIM HISTFILE
touch $HISTFILE 2> /dev/null || HISTFILE="$(eval cd ~$USER && pwd)/history/${HOST}/bash.${HIST_DTG}"

# --------------------------------------------------
# root specific tweaks
# --------------------------------------------------
[ "$me" = "root" ] && { umask 22; PS1='\[\e[0;31m\][\u@\h \W]\$\[\e[0m\] '; }

