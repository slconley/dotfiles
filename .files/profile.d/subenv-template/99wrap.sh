#!/bin/sh

env=example
export AWS_DEFAULT_PROFILE=${env}
export CDPATH="$CDPATH_BASE:$HOME/code/${env}:$HOME/GoogleDrive:$HOME/OneDrive"
export EYAML_CONFIG=~/.eyaml/config.${env}.yaml

# this must be last because it uses 'exec' 
eval $($HOME/.files/bin/get-aws-profile)
