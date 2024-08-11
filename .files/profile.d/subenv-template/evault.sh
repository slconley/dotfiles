evault=/path/to/ansible/vault-xyz.env
[ -r $evault ] && source <(ansible-vault view $evault)
