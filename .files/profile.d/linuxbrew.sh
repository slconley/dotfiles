# shellcheck shell=bash

BREWHOME=""
[ -d "$HOME/.linuxbrew" ] && BREWHOME=$HOME/.linuxbrew
[ -d /home/linuxbrew/.linuxbrew ] && BREWHOME=/home/linuxbrew/.linuxbrew

if [ -n "$BREWHOME" ]; then
  PATH="$BREWHOME/bin:$PATH"
  MANPATH="$BREWHOME/share/man:$MANPATH"
  INFOPATH="$BREWHOME/share/info:$INFOPATH"
fi
