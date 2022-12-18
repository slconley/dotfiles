# shellcheck shell=bash

[[ $- == *i* ]] || return

[ -d /home/linuxbrew/.linuxbrew/opt/fzf ] && fzf_home=/home/linuxbrew/.linuxbrew/opt/fzf
[ -d /usr/local/opt/fzf ] && fzf_home=/usr/local/opt/fzf
[ -d ~/.fzf/bin ] && fzf_home=~/.fzf
[ -d $fzf_home/bin ] && PATH=$PATH:$fzf_home/bin || return
which fzf > /dev/null 2>&1 || return

sources=(
  ~/.fzf.bash
  /etc/profile.d/fzf.sh
  /usr/share/doc/fzf/examples/{completion,key-bindings}.bash
  "$fzf_home/shell/{completion,key-bindings}.bash"
)

for f in "${sources[@]}"; do
  [ -f "$f" ] && source "$f" 2> /dev/null
done

