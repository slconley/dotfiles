# ----------------------------------------------------------------------
# last one wins; default to $HOME
[ -d ~/.zsh4humans ] && ZDOTDIR=~/zsh4humans
[ -d ~/.zinit/bin  ] && ZDOTDIR=~/.zinit
ZDOTDIR=$HOME
export ZDOTDIR="${ZDOTDIR:-$HOME}"

# ----------------------------------------------------------------------
# for rough tracing, when needed
# source() { echo $SHELL sourcing: $1; builtin source $1; }
# .() { echo $SHELL sourcing: $1; builtin source $1; } 


