# Terraform: OpenStack-Inet

Creates a fake-inet with a fake-inet-dns-server

## TODO: BOOSTER Configuration

```
module "internet" {
  source = "git@github.com:ait-cs-IaaS/terraform-openstack-inet.git"
  router_name = var.router_name
  dnsimage_id = openstack_images_image_v2.ubuntu-bionic-amd64.id
}
```
