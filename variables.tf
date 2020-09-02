variable "cidr" {
	type = string
	description = "Subnet-ID"
	default = "240.168.200.0/24"
}

variable "dns_ip" {
	type = string
	description = "Subnet-ID"
	default = "240.168.200.3"
}

variable "external_dns" {
        type = list(string)
        description = "DNS server"
        default = [ "8.8.8.8" ]
}

variable "dns_image" {
	type = string
	description = "image to boot the dns-server from"
}

variable "dns_flavor" {
	type = string
	description = "instance flavor for the dns-server"
	default = "m1.tiny"
}

variable "dns_sshkey" {
	type = string
	description = "ssh key of the firewall"
	default = "cyberrange-key"
}

variable "router_name" {
	type = string
	description = "Name of the public router"
}
