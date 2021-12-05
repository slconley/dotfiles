# shellcheck shell=bash

xcloud=$HOME/xcloud
CDPATH_BASE=".:$HOME:$HOME/.files:$HOME/.local:$HOME/.local/cdpath:$HOME/code:$HOME/.local/var/$HOST"
CDPATH_BASE="${CDPATH_BASE}:$xcloud:$xcloud/code:$xcloud/code/wip:$xcloud/share:$HOME/share:$HOME/opt/share"
CDPATH_BASE="${CDPATH_BASE}:$HOME/.var/$HOST:$HOME/.tmp/$HOST"
CDPATH="${CDPATH_BASE}"
export CDPATH CDPATH_BASE
