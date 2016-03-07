#!/bin/sh -ex
glance image-create \
       --copy-from http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img \
       --disk-format qcow2 --container-format bare \
       --name cirros
