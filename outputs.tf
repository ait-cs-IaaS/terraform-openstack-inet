# return the network_id, subnet_id, and the cidr of the fake-internet
output "network_id" { value = module.internet.network_id }
output "subnet_id" { value = module.internet.subnet_id }
output "cidr" { value = var.internet_cidr }