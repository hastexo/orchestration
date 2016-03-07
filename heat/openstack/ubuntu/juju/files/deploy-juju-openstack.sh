#!/bin/bash -ex

juju deploy --config=/home/training/juju-config.yaml mysql --to lxc:1
juju deploy --config=/home/training/juju-config.yaml rabbitmq-server --to lxc:1

sleep 120s

juju deploy --config=/home/training/juju-config.yaml keystone --to lxc:1
juju add-relation keystone:shared-db mysql:shared-db

juju deploy --config=/home/training/juju-config.yaml glance --to lxc:1
juju add-relation glance:identity-service keystone:identity-service
juju add-relation glance:shared-db mysql:shared-db

juju deploy --config=/home/training/juju-config.yaml neutron-api --to lxc:1
juju add-relation neutron-api:amqp rabbitmq-server:amqp
juju add-relation neutron-api:identity-service keystone:identity-service
juju add-relation neutron-api:shared-db mysql:shared-db

juju deploy --config=/home/training/juju-config.yaml neutron-gateway --to 3
juju add-relation neutron-gateway:amqp rabbitmq-server:amqp
juju add-relation neutron-gateway:neutron-plugin-api neutron-api:neutron-plugin-api
juju add-relation neutron-gateway:shared-db mysql:shared-db

juju deploy --config=/home/training/juju-config.yaml nova-cloud-controller --to lxc:1
juju add-relation nova-cloud-controller:amqp rabbitmq-server:amqp
juju add-relation nova-cloud-controller:identity-service keystone:identity-service
juju add-relation nova-cloud-controller:image-service glance:image-service
juju add-relation nova-cloud-controller:neutron-api neutron-api:neutron-api
juju add-relation nova-cloud-controller:shared-db mysql:shared-db

juju deploy --config=/home/training/juju-config.yaml nova-compute --to 2
juju add-relation nova-compute:amqp rabbitmq-server:amqp
juju add-relation nova-compute:cloud-compute nova-cloud-controller:cloud-compute
juju add-relation nova-compute:image-service glance:image-service
juju add-relation nova-compute:shared-db mysql:shared-db

juju deploy --config=/home/training/juju-config.yaml neutron-openvswitch
juju add-relation neutron-openvswitch:amqp rabbitmq-server:amqp
juju add-relation neutron-openvswitch:neutron-plugin-api neutron-api:neutron-plugin-api
juju add-relation neutron-openvswitch:neutron-plugin nova-compute:neutron-plugin 

juju deploy --config=/home/training/juju-config.yaml cinder cinder-api --to lxc:1
juju add-relation cinder-api:amqp rabbitmq-server:amqp
juju add-relation cinder-api:cinder-volume-service nova-cloud-controller:cinder-volume-service
juju add-relation cinder-api:identity-service keystone:identity-service
juju add-relation cinder-api:image-service glance:image-service
juju add-relation cinder-api:shared-db mysql:shared-db

juju deploy --config=/home/training/juju-config.yaml cinder cinder-volume --to 4
juju add-relation cinder-volume:amqp rabbitmq-server:amqp
juju add-relation cinder-volume:shared-db mysql:shared-db
juju add-relation cinder-volume:image-service glance:image-service

juju deploy --config=/home/training/juju-config.yaml openstack-dashboard --to 1
juju add-relation openstack-dashboard:identity-service keystone:identity-service

juju deploy --config=/home/training/juju-config.yaml heat --to lxc:1
juju add-relation heat:amqp rabbitmq-server:amqp
juju add-relation heat:identity-service keystone:identity-service
juju add-relation heat:shared-db mysql:shared-db
