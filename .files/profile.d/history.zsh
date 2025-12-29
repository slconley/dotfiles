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
HISTFILE_GLOBAL="$HISTBASE/.global/zsh.global"
HISTORY_IGNORE='( |AWS|HIST|cp |d[fu] |e[bmsz ]|exec |h[h]* |l[lst ]|lpass|man |mv |open |otr|p |psg |rm |s|sleep|which)*'
SAVEHIST=$HISTSIZE
export HISTFILE HISTORY_IGNORE SAVEHIST

h()   { fc -ln 1 | grep -i ${*:-''} | tail -50; }
hh()  { fc -ln 1 | grep -i --color=always "$1"; }
hhh() { readhist; fc -ln 1 | grep -ih $COLOR_GREP "$1" }
readhist()      { savehist; HISTSIZE=$HISTSIZE_GLOBAL; fc -R $HISTFILE_GLOBAL; fc -R $HISTFILE; }
savehist()      { [ "$HISTFILE" ] || return; fc -AI 2>/dev/null; SAVEHIST=$HISTSIZE_GLOBAL fc -AI "$HISTFILE_GLOBAL" 2>/dev/null; }

add-zsh-hook periodic savehist

# TODO: follow up on curated histfiles, utilizing $HISTBASE/.global/zsh.curated (or the like)
makehist() {
  local f; savehist; HISTSIZE=0; HISTSIZE=$HISTSIZE_GLOBAL; SAVEHIST=$HISTSIZE;
  for f in ${HISTBASE}/.global/zsh* $HISTDIR/zsh*[0-9]; do; fc -R "$f" 2> /dev/null; done;
  fc -W $HISTFILE_GLOBAL; cp $HISTFILE_GLOBAL $HISTFILE; HISTSIZE=0; HISTSIZE=$SAVEHIST; fc -R
}

# same concept but much more inclusive while attempting to still favor local host
MAKEHIST() {
  setopt nullglob
  [ -f "${HISTFILE_GLOBAL}" ] && cp -p "${HISTFILE_GLOBAL}" "${HISTFILE_GLOBAL}.${HIST_DTG}"
  local f; savehist; HISTSIZE=0; HISTSIZE=$HISTSIZE_GLOBAL; SAVEHIST=$HISTSIZE; cp /dev/null $HISTFILE_GLOBAL
  # fc -ln -t '%s' 1 | while read time cmd; do; printf ': %s:0;%s\n' $time $cmd; done | sort -no $HISTFILE_GLOBAL
  for f in $HISTBASE/*/bash*[0-9] $HISTDIR/bash*[0-9]; do; bash-to-zsh-hist < $f >> $HISTFILE_GLOBAL; done;
  for f in ${HISTBASE}/.global/zsh* $HISTBASE/*/zsh*[0-9] $HISTDIR/zsh*[0-9]; do; fc -R "$f" 2>/dev/null; done;
  fc -W $HISTFILE_GLOBAL; cp $HISTFILE_GLOBAL $HISTFILE; HISTSIZE=0; HISTSIZE=$SAVEHIST; fc -R
  setopt nonullglob
}

trap 'savehist;' EXIT HUP TERM QUIT

touch $HISTFILE 2> /dev/null || { [ -d ~$LOGNAME/... ] && HOME=~$LOGNAME/... && exec zsh }
unset d

# map <ctrl>e to invoke fc edit
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-e' edit-command-line

[ -d "$HISTDIR" ] || mkdir -m 700 -p $HISTDIR $HISTBASE/.global 2>/dev/null
[ -f "$HISTFILE" ] && [ -f "$HISTFILE_GLOBAL" ] || { touch "$HISTFILE" "$HISTFILE_GLOBAL";  makehist; }

