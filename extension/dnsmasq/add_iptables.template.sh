#!/usr/bin/env bash

for protocol in tcp udp; do
    for dns in $DNS_IPS; do
        RULE="-t nat -p $protocol --destination $dns -m set ! --match-set no_dns_caching_mac_set src --destination-port 53 -j DNAT --to-destination $LOCAL_IP:8853"
        sudo iptables -w -C FW_PREROUTING $RULE &>/dev/null || sudo iptables -w -I FW_PREROUTING 1 $RULE
    done
done

BLACK_HOLE_IP="0.0.0.0"
sudo iptables -w -C FW_FORWARD --destination $BLACK_HOLE_IP -j REJECT &>/dev/null || sudo iptables -w -A FW_FORWARD --destination $BLACK_HOLE_IP -j REJECT
