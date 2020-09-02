terraform {
  backend "consul" {}
}

data "openstack_images_image_v2" "dns" {
  name        = var.dns_image
  most_recent = true
}

data "openstack_networking_router_v2" "public_router" {
  name = var.router_name
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

resource "openstack_networking_network_v2" "internet" {
  name           = "internet"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "inet-subnet" {
  name       = "subnet-internet"
  network_id = openstack_networking_network_v2.internet.id
  cidr       = var.cidr
  dns_nameservers = var.external_dns
  ip_version = 4
}



resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = data.openstack_networking_router_v2.public_router.id
  subnet_id = openstack_networking_subnet_v2.inet-subnet.id
}

# Create dns server instance
resource "openstack_compute_instance_v2" "dns" {
  name               = "internet-dns"
  flavor_name        = var.dns_flavor
  key_pair           = var.dns_sshkey

  user_data = data.template_cloudinit_config.cloudinit.rendered

  metadata = {
    groups = "internet, dns"
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.dns.id
    source_type           = "image"
    volume_size           = 10
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    port = openstack_networking_port_v2.inetdns-port.id
  }
}

resource "openstack_networking_port_v2" "inetdns-port" {
  name           = "inetdns-port"
  network_id     = openstack_networking_network_v2.internet.id
  admin_state_up = "true"
  no_security_groups = true
  port_security_enabled = false
  fixed_ip { 
      subnet_id = openstack_networking_subnet_v2.inet-subnet.id
      ip_address = var.dns_ip
  }
}

