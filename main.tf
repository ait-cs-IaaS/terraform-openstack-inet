data "openstack_networking_router_v2" "public_router" {
  name = var.router_name
}

resource "openstack_networking_network_v2" "internet" {
  name           = var.internet_name
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "inet-subnet" {
  name            = "subnet-${var.internet_name}"
  network_id      = openstack_networking_network_v2.internet.id
  cidr            = var.cidr
  dns_nameservers = var.external_dns
  ip_version      = 4
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = data.openstack_networking_router_v2.public_router.id
  subnet_id = openstack_networking_subnet_v2.inet-subnet.id
}

module "dns" {
  source             = "git@github.com:ait-cs-IaaS/terraform-openstack-srv_noportsec.git?ref=v1.4.2"
  hostname           = var.dns_name
  tag                = var.dns_tag
  host_address_index = var.dns_host_address_index
  image              = var.dns_image
  flavor             = var.dns_flavor
  volume_size        = var.dns_volume_size
  use_volume         = var.dns_use_volume
  sshkey             = var.sshkey
  network            = openstack_networking_network_v2.internet.id
  subnet             = openstack_networking_subnet_v2.inet-subnet.id
  userdatafile       = var.dns_userdata == null ? "${path.module}/scripts/dnscloudinit.yml" : var.dns_userdata
  userdata_vars      = var.dns_userdata_vars
}
