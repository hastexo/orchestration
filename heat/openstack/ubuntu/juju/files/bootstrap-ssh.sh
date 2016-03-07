#!/bin/bash -ex

# Create an SSH key pair
ssh-keygen

# Add remote machines to Juju
for node in {deploy,alice,bob,charlie,daisy}.example.com; do
    ssh-copy-id $node
done
