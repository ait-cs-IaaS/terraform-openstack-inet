output "subnet_id" {
  value = openstack_networking_subnet_v2.inet-subnet.id
}

output "network_id" {
  value = openstack_networking_network_v2.internet.id
}

