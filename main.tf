# search public router by name and receive all the data
data "openstack_networking_router_v2" "public_router" {
  name = var.public_router_name
}

# create the network and subnet for the fake-internet
module "internet" {
  source  = "git@github.com:ait-cs-IaaS/terraform-openstack-network.git"
  name    = "internet"
  cidr    = var.internet_cidr
  dns_nameservers = ["8.8.8.8"]
}

# create an interface between fake-internet and real internet on the public router
resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = data.openstack_networking_router_v2.public_router.id
  subnet_id = module.internet.subnet_id
}

# create a local DNS server on the fake-internet
module "internet_dns_server" {
    source = "git@github.com:ait-cs-IaaS/terraform-openstack-srv_noportsec.git"
    count = var.create_dns ? 1 : 0 # if var.create_dns is true, create one dns server, otherwise don't create it
    name = "internet_dns"
    cidr = var.internet_cidr
    host_index = 5
    image = var.dns_image
    flavor = var.dns_flavor
    network_id = module.internet.network_id
    subnet_id = module.internet.subnet_id
}