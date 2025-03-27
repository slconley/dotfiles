# shellcheck shell=bash

[ "$OSNAME" = "Darwin" ] || return

[ -d "/Applications/VMware Fusion.app/Contents/Library" ] && PATH="$PATH:/Applications/VMware Fusion.app/Contents/Library"
# unset COLOR_LS
# export CLICOLOR=""

export TOP="-s3 -o cpu"

alias top="top -u"
alias serial='screen -U /dev/tty.usbserial-A9VUAB8G 115200'		 # -U is UTF-8 mode

export SYSLOG=(/var/log/{system.log,wifi.log})

