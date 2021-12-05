[ -f $HOME/.globalrc ] && source $HOME/.globalrc || return

# profiling/tracing (when needed; also see block at bottom)
# zmodload zsh/zprof
# PS4=$'\\\011%D{%s%6.}\011%x\011%I\011%N\011%e\011'
# exec 3>&2 2> $HOME/zshstart.$$.log
# setopt xtrace prompt_subst

# for rough tracing, when needed
# source() { echo $SHELL sourcing: $1; builtin source $1; }
# .() { echo $SHELL sourcing: $1; builtin source $1; }

# zinit on/off/exclusive?
[ -f ~/.zinit/.zshrc ] && { source ~/.zinit/.zshrc; unalias gr 2>/dev/null; }
# return 0

setopt nullglob
for f in $LPROFILES/pre-*.{,z}sh ; source $f
for f in $PROFILES/*.{,z}sh $PROFILES/.profile.${OSNAME}*; source $f
for f in $LPROFILES/post-*.{,z}sh ; source $f
for f in $PROFILES/$SUBENV/*.{,z}sh ; source $f
for f in $LPROFILES/$SUBENV/*.{,z}sh ; source $f
setopt nonullglob
unset f

typeset -U path cdpath manpath fpath    # remove dupes

# unsetopt xtrace
# exec 2>&3 3>&-
# zprof            # for profiling
