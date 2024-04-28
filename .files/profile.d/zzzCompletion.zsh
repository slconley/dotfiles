# shellcheck shell=sh

mkdir -p $XDG_RUNTIME_DIR/zsh/functions
alias compinit='compinit -C -d $XDG_RUNTIME_DIR/zsh/zcompdump'

declare -a fplist
fplist=( /usr/local/share/zsh-completions ~/.files/zsh/functions $XDG_RUNTIME_DIR/zsh/functions )
for d in $fplist; { [ -d "$d" ] && fpath=($d $fpath); }

[ -f ~$XDG_RUNTIME_DIR/zsh/functions/_kubectl ] || command kubectl completion zsh > $XDG_RUNTIME_DIR/zsh/functions/_kubectl 2> /dev/null
[ -f $XDG_RUNTIME_DIR/zsh/functions/_helm ] || helm completion zsh > $XDG_RUNTIME_DIR/zsh/functions/_helm 2> /dev/null

# aws fallback completion
[ "${functions[_aws]}" ] && {
  declare -a aws_completer_scripts
  aws_completer_scripts=( "${commands[aws]%%aws}aws_zsh_completer.sh" /usr/local/share/zsh/site-functions/aws_zsh_completer.sh /usr/bin/aws_zsh_completer.sh )
  for f in ${aws_completer_scripts[@]}; { [ -f $f ] && source $f && break; }		# first match wins
}

profile_dirs=(~/.local/profile.d ~/.files/profile.d)
compctl -g '*' -W /etc/init.d start status stop restart
compctl -k "(all rhel6)" -x 'p[2]' -f -- dist2
compctl -g '*' -W ~/var/.config myconfig
compctl -W profile_dirs -/ getenv
autoload -U compinit
compinit
compdef _vars e
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# ------------------------------------------------------------------------------------------
_pssh() { _arguments : '-h+:hosts:( ~/.local/pssh-hosts/*(DN) )' '*: : _default' ;}
compdef _pssh pssh pscp
compdef _path_commands h hh hhh
# ------------------------------------------------------------------------------------------


fzf_sources=( /etc/profile.d/fzf.sh /usr/share/doc/fzf/examples/{completion,key-bindings}.zsh $fzf_home/shell/{completion,key-bindings}.zsh)
for f in $fzf_sources; [ -f "$f" ] && source "$f" 2> /dev/null 
unset aws_completer_scripts fzf_sources c d f

# vi:filetype=zsh

