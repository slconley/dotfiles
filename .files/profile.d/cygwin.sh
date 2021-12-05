# shellcheck shell=bash

[ "$OSTYPE" = "cygwin" ] || return

PATH=$PATH:$CYGPATH
DESKTOP="$(cygpath -u "$USERPROFILE")/Desktop"        # alternates (vice USERPROFILE): HOMESHARE, HOMEDRIVE
export DESKTOP
