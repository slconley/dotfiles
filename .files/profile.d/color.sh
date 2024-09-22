[ "$ZSH_NAME" ] && GRC="$commands[grc]"
[ "$BASH" ] && GRC="$(type -p grc)"

[ "$TERM" = dumb ] || [ -z "$GRC" ] && return

# note to self...  having grc color always on messes up completion for grc-fronted commands
declare -a GRC_OPTIONS
GRC_OPTIONS=(-es --colour=auto); export GRC GRC_OPTIONS

color_cmds=(
  ant as blkid cc configure curl cvs df diff dig dnf docker docker-compose docker-machine
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

alias c+="GRC='grc' GRC_OPTIONS=(-es --colour=on) COLOR_GREP='--color=always' COLOR_LS='--color=always'"
alias c-="GRC='' GRC_OPTIONS='' COLOR_GREP='--color=never' COLOR_LS='--color=never'"
alias color='$GRC $GRC_OPTIONS'
