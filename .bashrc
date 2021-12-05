# shellcheck shell=bash

[ -f $HOME/.globalrc ] && source $HOME/.globalrc || return

# source() { echo $SHELL sourcing: $1; builtin source $1; }            # for rough tracing

shopt -s nullglob
for f in $LPROFILES/pre-*.{,ba}sh ; do source $f; done
for f in $PROFILES/*.{,ba}sh $PROFILES/.profile.${OSNAME}*; do source $f; done
for f in $LPROFILES/post-*.{,ba}sh ; do source $f; done
for f in $PROFILES/$SUBENV/*.{,ba}sh ; do source $f; done
for f in $LPROFILES/$SUBENV/*.{,ba}sh ; do source $f; done
shopt -u nullglob

