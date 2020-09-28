#!/usr/bin/sh

ansible all -i inventory.yml \
  -a '/usr/bin/curl curl -s localhost:8008/metrics' | \
    grep "^libp2p_peers \|^beacon_current_epoch \|^beacon_head_slot " | \
    column -t
