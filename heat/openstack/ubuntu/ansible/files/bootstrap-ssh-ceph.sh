#!/bin/bash -ex

# Create an SSH key pair
ssh-keygen

for node in {alice,bob,charlie,daisy,eric,frank}.example.com; do
    ssh-copy-id $node
done
