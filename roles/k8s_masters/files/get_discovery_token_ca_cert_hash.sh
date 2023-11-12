#!/usr/bin/env bash
log_err() { echo "$(date) - ERROR: $1" >&2; }

main() {
    local cert_hash

    cert_hash=$(openssl x509 -in /etc/kubernetes/pki/ca.crt -noout -pubkey | openssl rsa -pubin -outform DER 2>/dev/null | sha256sum | cut -d' ' -f1)

    if [ -z "$cert_hash" ]; then
        log_err "Failed to get discovery_token_ca_cert_hash to join k8s cluster. The command of output was empty. (command=openssl x509 -in /etc/kubernetes/pki/ca.crt -noout -pubkey | openssl rsa -pubin -outform DER 2>/dev/null | sha256sum | cut -d' ' -f1)"
        return 1
    fi

    if [[ ! "$cert_hash" =~ ^[0-9a-f]{64}$ ]]; then
        log_err "Failed to get discovery_token_ca_cert_hash to join k8s cluster. The command of output was difference from sha256 hash (expected_regex=^[0-9a-f]{64}\$, actual_output=${cert_hash}, command=openssl x509 -in /etc/kubernetes/pki/ca.crt -noout -pubkey | openssl rsa -pubin -outform DER 2>/dev/null | sha256sum | cut -d' ' -f1)."
        return 1
    fi

    echo "$cert_hash"

    return 0
}

main "$@"
