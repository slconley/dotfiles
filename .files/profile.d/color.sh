export COLOR_GREP="--color=always"
export COLOR_LS="--color=always"
export COLOR_JQ="-C"

alias c+="COLOR_GREP='--color=always' COLOR_LS='--color=always'"
alias c-="COLOR_GREP='--color=never' COLOR_LS='--color=never' COLOR_JQ='-M'"

# --------------------------------------------------------------------------------
# notes:
#   - remainder of colorization depends on grc availability
#   - default grc mode is always on
#   - having grc color always on messes up completion for grc-fronted commands
#   - use the 'c-' alias to disable when necessary
# --------------------------------------------------------------------------------
[ "$ZSH_NAME" ] && GRC="$commands[grc]"
[ "$BASH" ] && GRC="$(type -p grc)"

[ "$TERM" = dumb ] || [ -z "$GRC" ] && return

declare -a GRC_OPTIONS
GRC_OPTIONS=(-es --colour=on); export GRC GRC_OPTIONS

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
  for c in ${color_cmds[@]} ; do [ "$commands[$c]" ] && $c() { $GRC $GRC_OPTIONS ${commands[$0]} "$@";}; done
else
  for c in ${color_cmds[@]} ; do alias ${c}="color $c"; done
fi

alias color='$GRC $GRC_OPTIONS'
alias c+="GRC='grc' GRC_OPTIONS=(-es --colour=on) COLOR_GREP='--color=always' COLOR_LS='--color=always'"
alias c-="GRC='' GRC_OPTIONS=() COLOR_GREP='--color=never' COLOR_LS='--color=never' COLOR_JQ='-M'"
