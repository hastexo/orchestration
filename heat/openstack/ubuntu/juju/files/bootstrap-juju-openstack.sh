#!/bin/bash -ex

# Create an SSH key pair
ssh-keygen

# Bootstrap the Juju server
juju bootstrap -v --debug
sleep 10s

# Deploy the Juju GUI to the server
juju deploy juju-gui --to=0

# Add remote machines to Juju
for node in {alice,bob,charlie,daisy}.example.com; do
    ssh-copy-id $node
    juju add-machine ssh:$node
done
