output "subnet_id" {
  value = openstack_networking_subnet_v2.inet-subnet.id
}

output "subnet_name" {
  value = openstack_networking_subnet_v2.inet-subnet.name
}

output "network_id" {
  value = openstack_networking_network_v2.internet.id
}

output "network_name" {
  value = openstack_networking_network_v2.internet.name
}

output "dns_id" {
  value = module.dns.server.id
}

output "dns_ip" {
  value = module.dns.server.network[0].fixed_ip_v4
}

