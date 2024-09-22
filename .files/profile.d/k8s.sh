which kubectl > /dev/null 2>&1 || return

[ "$BASH" ] && source <(kubectl completion bash)

export KXSHELL=/bin/sh
export KUBECONFIG=$(echo $HOME/.kube/config*| tr ' ' ':')

kx() { kubectl exec -it $* -- $KXSHELL; }

alias k='kubectl'
alias ka='kubectl --all-namespaces'
alias kc='kubectl config'
alias kcs='kubectl config get-contexts'
alias kdp='kubectl describe pod'
alias kk='kubectl krew'

alias kd='kubectl -n default'
alias ke='kubectl -n elastic'
alias ki='kubectl -n infrastructure'
alias km='kubectl -n monitoring'
alias ks='kubectl -n kube-system'

alias kdr='kubectl --dry-run=client -o yaml'
alias kbb='kubectl run busybox-test --image=busybox -it --rm --restart=Never --'

# ----------------------------------------------------------------------------------------------------
# krew is a kubectl pluign manager.
# check out this page for install instructions: https://github.com/kubernetes-sigs/krew
# the following line just enables it if already installed.
# ----------------------------------------------------------------------------------------------------
[ -d $HOME/.krew ] && { 
  export KREW_ROOT=$HOME/.krew
  d=$KREW_ROOT/bin; [[ "$PATH" =~ (^|:)"${d}"(:|$) ]] || PATH=$PATH:$d; unset d
}


