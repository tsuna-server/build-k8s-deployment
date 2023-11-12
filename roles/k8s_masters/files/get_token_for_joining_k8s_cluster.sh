#!/usr/bin/env bash
log_err() { echo "$(date) - ERROR: $1" >&2; }
log_info() { echo "$(date) - INFO: $1"; }

main() {
    local ret token

    token="$(kubeadm token list -o json | jq -r '.token')"
    ret=$?

    # Has jq command succeeded?
    if [ $ret -ne 0 ]; then
        log_err "Failed to run jq command(kubeadm token list -o json | jq -r '.token'). Its return code was ${ret}. Or has jq command installed?"
        return 1
    fi

    if [ -z "$token" ]; then
        log_err "Failed to get a token for joining k8s cluaster with command \"kubeadm token list -o json | jq -r '.token'\"."
        return 1
    fi

    echo "$token"

    return 0
}

main "$@"
