# Terraform: OpenStack-Inet

Creates a fake-inet with a fake-inet-dns-server

# Configuration

```
module "internet" {
	source = "git@git-service.ait.ac.at:sct-cyberrange/terraform-modules/openstack-inet.git"
	router_name = var.router_name
	dnsimage_id = openstack_images_image_v2.ubuntu-bionic-amd64.id
}
```

