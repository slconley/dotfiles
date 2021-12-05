#!/bin/sh

export KUBECONFIG=$HOME/.kube/config
unset TILLER_NAMESPACE
#kubectl config use-context docker-desktop
