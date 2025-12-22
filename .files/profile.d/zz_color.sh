export COLOR_GREP="--color=always"
export COLOR_LS="--color=always"
export COLOR_JQ="-C"

alias c+="COLOR_GREP='--color=always' COLOR_LS='--color=always' COLOR_JQ='-C'"
alias c-="COLOR_GREP='--color=never' COLOR_LS='--color=never' COLOR_JQ='-M'"

# --------------------------------------------------------------------------------
# notes:
#   - remainder of colorization depends on grc availability
#   - default grc mode is always on
#   - having grc color always on messes up completion for grc-fronted commands
#   - use the 'c-' alias to disable when necessary
# --------------------------------------------------------------------------------
declare -a GRC GRC_NORM
[ "$ZSH_NAME" ] && GRC=($commands[grc])
[ "$BASH" ] && GRC=($(type -p grc))

[ "$TERM" = dumb ] || [ -z "$GRC" ] && return

GRC=(grc -es --colour=on); export GRC
GRC_NORM=(${GRC[@]})

# disabled commands: dnf yum
color_cmds=(
  ant as blkid cc configure curl cvs df diff dig docker docker-compose docker-machine
  du env fdisk findmnt free g++ gas gcc getfacl getsebool gmake head id ifconfig iostat
  ip iptables iwconfig journalctl kubectl last ld ldap lolcat ls lsattr lsblk lsmod lsof
  lspci make mount mtr mvn netstat nmap ntpdate php ping ping6 proftpd ps sar semanage
  sensors showmount sockstat ss stat sysctl systemctl tail tcpdump traceroute traceroute6
  tune2fs ulimit uptime vmstat wdiff whois
)

if [ "$ZSH_NAME" ]; then
  alias c+="GRC=(grc -es --colour=on) GRC_NORM=($GRC) COLOR_GREP='--color=always' COLOR_LS='--color=always' COLOR_JQ='-C' "
  alias c-="GRC=command GRC_NORM='' COLOR_LS='--color=never' COLOR_JQ='-M'"
  for c in ${color_cmds[@]} ; do [ "$commands[$c]" ] && $c() { $GRC ${commands[$0]} "$@";}; done
  _grc_off()   { GRC=''; comppostfuncs+=(_grc_reset); return 1; }  # always disable during completion
  _grc_reset() { GRC=($GRC_NORM); }
  zstyle ':completion:*' completer _grc_off _complete _ignored
else
  alias c+="GRC='grc -es --colour=on' GRC_NORM=($GRC) COLOR_GREP='--color=always' COLOR_LS='--color=always' COLOR_JQ='-C' "
  alias c-="GRC=() GRC=command COLOR_LS='--color=never' COLOR_JQ='-M'"
  for c in ${color_cmds[@]} ; do eval function $c ' { ${GRC[@]} '$c' $@; } '; done
fi

