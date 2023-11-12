#!/usr/bin/env bash
log_err() { echo "$(date) - ERROR: $1" >&2; }

main() {
    local ip
    ip="$(getent hosts "$(hostname)" | cut -d ' ' -f 1)"

    if [ -z "${ip}" ]; then
        log_err "Failed to get IP address of host \"getent hosts \\\"\$(getent hosts \\\"\$(hostname)\\\" | cut -d ' ' -f 1)\\\"\". Its value was empty."
        return 1
    fi

    if [[ ! "${ip}" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        log_err "Failed to get IP address of host \"getent hosts \\\"\$(getent hosts \\\"\$(hostname)\\\" | cut -d ' ' -f 1)\\\"\". Its value was \"${ip}\""
        return 1
    fi

    echo -n "${ip}"

    return 0
}

main "$@"
