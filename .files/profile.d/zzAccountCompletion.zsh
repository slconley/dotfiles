# shellcheck shell=zsh

# hostname completion via known_hosts
[ -r ~/.ssh/known_hosts ] && myhosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || myhosts=()
zstyle -e ':completion:*:hosts' hosts 'reply=($myhosts)'

# account completion via defined config
my_accounts=()
[ -f $HOME/.config/enum/hosts ] && hosts=($(cat $HOME/.config/enum/hosts)) || hosts=()
[ -f $HOME/.config/enum/domains ] && domains=($(cat $HOME/.config/enum/domains)) || domains=()
[ -f $HOME/.config/enum/accounts ] && accounts=($(cat $HOME/.config/enum/accounts)) || accounts=()
accounts_spec="{$(echo $accounts | tr -s ' ' ',')}"
my_accounts=($my_accounts $(eval echo $accounts_spec))
for h in $hosts ; do
  my_accounts=($my_accounts $(eval echo ${accounts_spec}@$h))
  for d in $domains ; do
    my_accounts=($my_accounts $(eval echo ${accounts_spec}@$h.$d))
  done
done

# this must occur after defining 'my_accounts'
zstyle ':completion:*:my-accounts' users-hosts $my_accounts 

