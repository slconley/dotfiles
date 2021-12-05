# --------------------------------------------------------------------------------------------------------------
# minimum personal zinit setup - added via zinit installer
# --------------------------------------------------------------------------------------------------------------
init="$HOME/.zinit/bin/zinit.zsh"
[ -f "$init" ] && source "$init" || return

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node


# --------------------------------------------------------------------------------------------------------------
# other suggested config
# --------------------------------------------------------------------------------------------------------------

# Two regular plugins loaded without investigating.
## zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting

# Plugin history-search-multi-word loaded with investigating.
## zinit load zdharma/history-search-multi-word

# Load the pure theme, with zsh-async library that's bundled with it.
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# A glance at the new for-syntax – load all of the above
# plugins with a single command. For more information see:
# https://zdharma.github.io/zinit/wiki/For-Syntax/
## zinit for \
##     light-mode  zsh-users/zsh-autosuggestions \
##     light-mode  zdharma/fast-syntax-highlighting \
##                 zdharma/history-search-multi-word \
##     light-mode pick"async.zsh" src"pure.zsh" \
##                 sindresorhus/pure


# Binary release in archive, from GitHub-releases page.
# After automatic unpacking it provides program "fzf".
## zinit ice from"gh-r" as"program"
## zinit load junegunn/fzf-bin

# One other binary release, it needs renaming from `docker-compose-Linux-x86_64`.
# This is done by ice-mod `mv'{from} -> {to}'. There are multiple packages per
# single version, for OS X, Linux and Windows – so ice-mod `bpick' is used to
# select Linux package – in this case this is actually not needed, Zinit will
# grep operating system name and architecture automatically when there's no `bpick'.
## zinit ice from"gh-r" as"program" mv"docker* -> docker-compose" bpick"*linux*"
## zinit load docker/compose

# Vim repository on GitHub – a typical source code that needs compilation – Zinit
# can manage it for you if you like, run `./configure` and other `make`, etc. stuff.
# Ice-mod `pick` selects a binary program to add to $PATH. You could also install the
# package under the path $ZPFX, see: http://zdharma.github.io/zinit/wiki/Compiling-programs
# zinit ice as"program" atclone"rm -f src/auto/config.cache; ./configure" \
#     atpull"%atclone" make pick"src/vim"
# zinit light vim/vim

# Scripts that are built at install (there's single default make target, "install",
# and it constructs scripts by `cat'ing a few files). The make'' ice could also be:
# `make"install PREFIX=$ZPFX"`, if "install" wouldn't be the only, default target.
## zinit ice as"program" pick"$ZPFX/bin/git-*" make"PREFIX=$ZPFX"
## zinit light tj/git-extras

# Handle completions without loading any plugin, see "clist" command.
# This one is to be ran just once, in interactive session.
# zinit creinstall %HOME/my_completions


# zinit snippet 'https://github.com/robbyrussell/oh-my-zsh/raw/master/plugins/git/git.plugin.zsh'
# zinit snippet 'https://github.com/sorin-ionescu/prezto/blob/master/modules/helper/init.zsh'

## zinit snippet OMZ::plugins/git/git.plugin.zsh
## zinit snippet PZT::modules/helper/init.zsh

