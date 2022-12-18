# shellcheck shell=sh

[[ $- == *i* ]] || return

[ -d /home/linuxbrew/.linuxbrew/opt/fzf ] && fzf_home=/home/linuxbrew/.linuxbrew/opt/fzf
[ -d /usr/local/opt/fzf ] && fzf_home=/usr/local/opt/fzf
[ -d ~/.fzf/bin ] && fzf_home=~/.fzf
[ -d $fzf_home/bin ] && PATH=$PATH:$fzf_home/bin || return


# function overrides
f()   { print -z $(r -L | fzf;) }
hh()  { fc -ln 1 | grep -i $COLOR_GREP \.\?$*; }
hhh() { readhist; print -z $(fc -ln 1 | grep -ih $COLOR_GREP "$1" | fzf -q "$1";) }

