#!/bin/bash -ex

# Bootstrap the Juju server
juju bootstrap -v --debug
sleep 10s

# Deploy the Juju GUI to the server
juju deploy --config=/home/training/juju-config.yaml juju-gui --to=0

# Add remote machines to Juju
for node in {alice,bob,charlie,daisy}.example.com; do
    juju add-machine ssh:$node
done
