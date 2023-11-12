#!/usr/bin/env bash
log_err() { echo "$(date) - ERROR: $1" >&2; }

main() {
    local ip="$1"
    local escaped_ip interface_name ip_with_cidr network_address subnet_length

    if [[ ! "${ip}" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        log_err "A format of 1st argument is different from IP address \"^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$\". Actual value is \"${ip}\"."
        return 1
    fi
    escaped_ip="${ip//./\\.}"

    ip_with_cidr="$(ip addr show | grep -Po "inet \K${escaped_ip}/\d+")"
    if [[ ! "${ip_with_cidr}" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}$ ]]; then
        log_err "Faied to get IP address with cidr format with a command [ip addr show | grep -Po \"inet \\\K\${escaped_ip}/\\\d+\"]. Is an IP you specified ${ip} existed?"
        return 1
    fi

    IFS="/" read _ subnet_length <<< "${ip_with_cidr}"

    network_address=$(get_network_address "${ip}" "${subnet_length}")
    if [[ ! "${network_address}" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        log_err "Faied to get network address with a command [get_network_address \"${ip}\" \"${subnet_length}\"]. IP address ${ip} has existed but something went wrong."
        return 1
    fi

    echo -n "${network_address}/${subnet_length}"

    return 0
}

# https://stackoverflow.com/a/32690695
int2ip() {
    local ui32=$1; shift
    local ip n
    for n in 1 2 3 4; do
        ip=$((ui32 & 0xff))${ip:+.}$ip
        ui32=$((ui32 >> 8))
    done
    echo $ip
}

ip2int() {
    local a b c d
    { IFS=. read a b c d; } <<< $1
    echo $(((((((a << 8) | b) << 8) | c) << 8) | d))
}

# Example: network 192.0.2.0 24 => 192.0.2.0
get_network_address() {
    local addr=$(ip2int $1); shift
    local mask=$((0xffffffff << (32 -$1))); shift
    int2ip $((addr & mask))
}

main "$@"
