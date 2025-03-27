# shellcheck shell=sh

#unsetopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
# setopt hist_save_no_dups

# reminder... if HISTORY_IGNORE not completely working, you are potentially using an older zsh
HISTFILE="$HISTDIR/zsh.histfile.${HIST_DTG}"
HISTFILE_GLOBAL="$HISTBASE/.global/zsh.histfile"
# TODO: revisit - check if heredocs are working well in the main HISTFILE
# HISTORY_IGNORE='( *|#*|*<<*|AWS*|e[bmz ]|exec |h[h]* |l[lst ]|lpass*|man |open |otr|p |s|sleep|which)'
HISTORY_IGNORE='( *|AWS*|e[bmsz ]|exec |h[h]* |l[lst ]|lpass*|man |open |otr|p |s|sleep|which)'
PERIOD=300
SAVEHIST=$HISTSIZE
export HISTFILE HISTORY_IGNORE PERIOD SAVEHIST

h()   { fc -ln 1 | grep -i ${*:-''} | tail -50; }
hh()  { fc -ln 1 | grep -i --color=always "$1"; }
hhh() { readhist; fc -ln 1 | grep -ih $COLOR_GREP "$1" }
periodic()      { savehist; }
readhist()      { savehist; HISTSIZE=$HISTSIZE_GLOBAL; fc -R $HISTFILE_GLOBAL; fc -R $HISTFILE; }
savehist()      { [ "$HISTFILE" ] || return; fc -AI 2>/dev/null; SAVEHIST=$HISTSIZE_GLOBAL fc -AI "$HISTFILE_GLOBAL" 2>/dev/null; }
# TODO: revisit - check if heredocs are working well in the main HISTFILE
# zshaddhistory() { [[ "$1" =~ '^ ' ]] || print -Sr -- "${1%%$'\n'}"; [[ $1 =~ '<<' ]] && print "$1" >> ${HISTFILE}.heredoc; }

# TODO: introduce curated HISTFILEs
makehist() { 
  local f; savehist; HISTSIZE=0; HISTSIZE=$HISTSIZE_GLOBAL; SAVEHIST=$HISTSIZE;
  for f in ${HISTFILE_GLOBAL} ~/.var/hist/$NICK/zsh*[0-9]; do; fc -R "$f" 2> /dev/null; done; 
  fc -W $HISTFILE_GLOBAL; cp $HISTFILE_GLOBAL $HISTFILE; HISTSIZE=0; HISTSIZE=$SAVEHIST; fc -R
}

# same concept but much more inclusive while attempting to still favor local host
MAKEHIST() { 
  cp -p "${HISTFILE_GLOBAL}" "${HISTFILE_GLOBAL}.${HIST_DTG}"
  local f; savehist; HISTSIZE=0; HISTSIZE=$HISTSIZE_GLOBAL; SAVEHIST=$HISTSIZE; cp /dev/null $HISTFILE_GLOBAL
  # fc -ln -t '%s' 1 | while read time cmd; do; printf ': %s:0;%s\n' $time $cmd; done | sort -no $HISTFILE_GLOBAL
  for f in ~/.var/hist/*/bash*[0-9] ~/.var/hist/$NICK/bash*[0-9]; do; bash-to-zsh-hist < $f >> $HISTFILE_GLOBAL; done; 
  for f in ${HISTFILE_GLOBAL}* ~/.var/hist/*/zsh*[0-9] ~/.var/hist/$NICK/zsh*[0-9]; do; fc -R "$f" 2>/dev/null; done; 
  fc -W $HISTFILE_GLOBAL; cp $HISTFILE_GLOBAL $HISTFILE; HISTSIZE=0; HISTSIZE=$SAVEHIST; fc -R
}

trap 'savehist;' EXIT HUP

touch $HISTFILE 2> /dev/null || { [ -d ~$LOGNAME/... ] && HOME=~$LOGNAME/... && exec zsh }
unset d

# map <ctrl>e to invoke fc edit
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-e' edit-command-line

[ -d "$HISTDIR" ] || mkdir -p $HISTDIR $HISTBASE/.global 2>/dev/null
[ -f "$HISTFILE" ] && [ -f "$HISTFILE_GLOBAL" ] || { touch "$HISTFILE" "$HISTFILE_GLOBAL";  makehist; }

