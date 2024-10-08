#!/bin/bash

# determine if go already available
GOROOT="$(go env GOROOT 2> /dev/null)"

# otherwise try some potential install locations - last (existing) match wins!
[ -z "$GOROOT" ] && {
  for d in /usr/local/go /usr/local/opt/go/libexec; do
    [ -d "$d" ] && GOROOT=$d
  done 
  unset d
}

# complete nogo?
[ -z "$GOROOT" ] && return

GOPATH=$HOME/.go
PATH=$PATH:$GOPATH/bin:$GOROOT/bin
[ -d $GOPATH/bin ] || mkdir -p $GOPATH/bin
export GOROOT GOPATH

