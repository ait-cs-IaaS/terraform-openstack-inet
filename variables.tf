variable "cidr" {
        type = string
	description = "Subnet-ID"
	default = "240.168.200.0/24"
#	default = "192.168.200.0/24"
}

variable "dnsip" {
        type = string
	description = "Subnet-ID"
	default = "240.168.200.3"
#	default = "192.168.200.3"
}

variable "dns" {
        type = list(string)
        description = "DNS server"
        default = [ "8.8.8.8" ]
}

variable "dnsimage_id" {
	type = string
	description = "image to boot the dns-server from"
}

variable "dnsflavor" {
	type = string
	description = "instance flavor for the dns-server"
        default = "m1.tiny"
}

variable "dnssshkey" {
	type = string
        description = "ssh key of the firewall"
	default = "cyberrange-key"
}

variable "router_name" {
	type = string
	description = "Name of the public router"
}
