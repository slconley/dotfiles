# shellcheck shell=bash

[[ $- == *i* ]] || return

[ -d /home/linuxbrew/.linuxbrew/opt/fzf ] && fzf_home=/home/linuxbrew/.linuxbrew/opt/fzf
[ -d /usr/local/opt/fzf ] && fzf_home=/usr/local/opt/fzf
[ -d ~/.fzf/bin ] && fzf_home=~/.fzf
[ -d $fzf_home/bin ] && PATH=$PATH:$fzf_home/bin || return
[ -x /usr/bin/fzf ] && fzf_home=/usr
which fzf > /dev/null 2>&1 || return

sources=(
  /etc/profile.d/fzf.sh
  /usr/share/doc/fzf/completion.bash
  /usr/share/doc/fzf/key-bindings.bash
  /usr/share/doc/fzf/examples/completion.bash
  /usr/share/doc/fzf/examples/key-bindings.bash
  /usr/share/fzf/completion.bash
  /usr/share/fzf/key-bindings.bash
  /usr/share/fzf/examples/completion.bash
  /usr/share/fzf/examples/key-bindings.bash
  "$fzf_home/shell/completion.bash"
  "$fzf_home/shell/key-bindings.bash"
)

for f in "${sources[@]}"; do
  [ -f "$f" ] && source "$f" 2> /dev/null
done

