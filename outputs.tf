output "subnet_id" {
  value = openstack_networking_subnet_v2.inet-subnet.id
}

output "network_id" {
  value = openstack_networking_network_v2.internet.id
}

output "dns_ip" {
  value = openstack_networking_port_v2.inetdns-port.fixed_ip[0].ip_address
}

