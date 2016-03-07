#!/bin/sh -ex
neutron security-group-rule-create \
        --protocol icmp \
        default
neutron security-group-rule-create \
        --protocol tcp \
        --port-range-min=22 \
        --port-range-max=22 \
        default
