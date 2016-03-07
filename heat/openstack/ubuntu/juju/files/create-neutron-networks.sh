#!/bin/sh -ex
neutron net-create test-net
neutron subnet-create --name test-subnet \
	--dns-nameserver 8.8.8.8 \
	--dns-nameserver 8.8.4.4 \
	test-net 10.0.6.0/24
neutron net-create \
	--router:external=True \
	--provider:physical_network=external \
	--provider:network_type=flat \
	ext-net
neutron subnet-create --name ext-subnet \
	--allocation-pool start=192.168.144.200,end=192.168.144.250 \
	ext-net 192.168.144.0/24
neutron router-create test-router
neutron router-interface-add test-router test-subnet
neutron router-gateway-set test-router ext-net
