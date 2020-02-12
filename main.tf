provider "openstack" {
}

terraform {
  backend "consul" {}
}

resource "openstack_networking_network_v2" "internet" {
  name           = "internet"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "inet-subnet" {
  name       = "subnet-internet"
  network_id = "${openstack_networking_network_v2.internet.id}"
  cidr       = "${var.cidr}"
  dns_nameservers = "${var.dns}"
  ip_version = 4
}

data "openstack_networking_router_v2" "publicrouter" {
  name = "${var.router_name}"
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = "${data.openstack_networking_router_v2.publicrouter.id}"
  subnet_id = "${openstack_networking_subnet_v2.inet-subnet.id}"
}


data "template_file" "user_data" {
  template = "${file("${path.module}/scripts/dnscloudinit.yml")}"
}

data "template_cloudinit_config" "cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.user_data.rendered
  }
}

# resource "openstack_networking_secgroup_v2" "inetdns-sg" {
#   name        = "inetdns-sg"
#   description = "Security-Group for the internet-dns-server"
# }
# 
# resource "openstack_networking_secgroup_rule_v2" "inetdns-rule-01" {
#   direction         = "ingress"
#   ethertype         = "IPv4"
#   protocol          = "tcp"
#   port_range_min    = 22
#   port_range_max    = 22
#   remote_ip_prefix  = "0.0.0.0/0"
#   security_group_id = "${openstack_networking_secgroup_v2.inetdns-sg.id}"
# }
# 
# resource "openstack_networking_secgroup_rule_v2" "inetdns-rule-02" {
#   direction         = "ingress"
#   ethertype         = "IPv4"
#   protocol          = "udp"
#   port_range_min    = 53
#   port_range_max    = 53
#   remote_ip_prefix  = "0.0.0.0/0"
#   security_group_id = "${openstack_networking_secgroup_v2.inetdns-sg.id}"
# }

# Create instance
#
resource "openstack_compute_instance_v2" "dns" {
  name               = "internet-dns"
  flavor_name        = "${var.dnsflavor}"
  key_pair           = "${var.dnssshkey}"

  user_data = data.template_cloudinit_config.cloudinit.rendered

  metadata = {
    groups = "internet, dns"
  }

#  security_groups = ["inetdns-sg"]

  block_device {
    uuid                  = "${var.dnsimage_id}"
    source_type           = "image"
    volume_size           = 10
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    port = "${openstack_networking_port_v2.inetdns-port.id}"
  }
}

resource "openstack_networking_port_v2" "inetdns-port" {
  name           = "inetdns-port"
  network_id     = "${openstack_networking_network_v2.internet.id}"
  admin_state_up = "true"
  no_security_groups = true
  port_security_enabled = false
  fixed_ip { 
      subnet_id = "${openstack_networking_subnet_v2.inet-subnet.id}"
      ip_address = "${var.dnsip}"
  }
}

