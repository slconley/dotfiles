[ -d $HOME/.nvm ] && NVM_DIR="$HOME/.nvm" 
[ -d $XDG_CONFIG_HOME/nvm ] && NVM_DIR="$XDG_CONFIG_HOME/nvm" 
[ -z $NVM_DIR ] && return

export NVM_DIR

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

