#!/usr/bin/env bash

# Check whether k8s cluster has already initialized.
#   return 0: k8s cluaster has NOT initialized.
#   return 1: k8s cluaster has already initialized.
main() {
    [ -f "/etc/kubernetes/manifests/kube-apiserver.yaml" ] &&           return 1
    [ -f "/etc/kubernetes/manifests/kube-controller-manager.yaml" ] &&  return 1
    [ -f "/etc/kubernetes/manifests/kube-scheduler.yaml" ] &&           return 1
    [ -f "/etc/kubernetes/manifests/etcd.yaml" ] &&                     return 1

    return 0
}

main "$@"
