# shellcheck shell=bash

xcloud=$HOME/xcloud
CDPATH_BASE=".:$HOME:$HOME/.files:$HOME/.tmp/$HOST:$HOME/.local:$HOME/.local/cdpath:$HOME/code"
CDPATH_BASE="${CDPATH_BASE}:$xcloud:$xcloud/code:$xcloud/code/wip:$xcloud/share:$HOME/share:$HOME/opt/share"
CDPATH="${CDPATH_BASE}"
export CDPATH CDPATH_BASE
