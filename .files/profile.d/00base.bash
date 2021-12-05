# shellcheck shell=bash

# --------------------------------------------------
# good for debugging (use "set -x")
# --------------------------------------------------
export PS4='\[\e[0;33m\][${BASH_SOURCE[0]:-inherited}:${LINENO}:${FUNCNAME[0]:-main}]>>>\[\e[0m\] '

# --------------------------------------------------
# skip if non-interactive
# --------------------------------------------------
[ "$PS1" ] || return

# --------------------------------------------------
# completion
# --------------------------------------------------
complete -A directory cd 2> /dev/null
complete -C /usr/local/bin/terraform terraform
[[ -d /etc/init.d ]] && complete -W "$(command ls /etc/init.d/)" service stop start restart status 2> /dev/null
[[ -d ~/.local/pssh-hosts ]] && complete -W "$(command ls ~/.local/pssh-hosts)" pssh 2> /dev/null
for f in /etc/profile.d/bash_completion.sh /usr/local/etc/bash_completion.d/pass; do 
  [ -f "$f" ] && source "$f"
done 

# --------------------------------------------------
# key bindings
# --------------------------------------------------
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'
bind '"\C-?":kill-whole-line'
bind 'set completion-ignore-case on'

# --------------------------------------------------
# misc
# --------------------------------------------------
savehist() { history -a; }

# vi: ft=sh
