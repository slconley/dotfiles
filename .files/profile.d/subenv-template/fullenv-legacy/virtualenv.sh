which pyenv-virtualenv-init > /dev/null 2>&1 && eval "$(pyenv virtualenv-init -)"

# disable changing of prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1

# use virtualenvwrapper if installed
[ -f /usr/local/bin/virtualenvwrapper.sh ] && {
  source /usr/local/bin/virtualenvwrapper.sh
  [ "$VIRTUAL_ENV" ] && workon $(basename $VIRTUAL_ENV) && return
  [ -d $WORKON_HOME/default ] && workon default && return
}

# otherwise check for base virtualenv already in use, or with default env
[ -f "$VIRTUAL_ENV/bin/activate" ] && source $VIRTUAL_ENV/bin/activate && return
[ -f ~/.local/virtualenv/default/bin/activate ] && source ~/.local/virtualenv/default/bin/activate

