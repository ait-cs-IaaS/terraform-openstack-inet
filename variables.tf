variable "cidr" {
  type        = string
  description = "The CIDR to use for the internet networks subnet"
  default     = "240.168.200.0/24"
}

variable "router_name" {
  type        = string
  description = "Name of the public router"
}

variable "internet_name" {
  type        = string
  description = "Name of the internet network to create"
  default     = "internet"
}

variable "dns_name" {
  type        = string
  description = "The name to use for the internet DNS server"
  default     = "internet-dns"
}

variable "dns_tag" {
  type        = string
  description = "The groups to tag the DNS server for"
  default     = "internet, dns"
}

variable "dns_host_address_index" {
  type        = number
  description = "The host address index to use for the DNS server"
  default     = 3
}
variable "dns_image" {
  type        = string
  description = "image to boot the dns-server from"
}

variable "dns_volume_size" {
  type        = string
  description = "volume_size"
  default     = 10
}

variable "dns_use_volume" {
  type        = bool
  description = "If the a volume or a local file should be used for storage"
  default     = false
}

variable "dns_flavor" {
  type        = string
  description = "instance flavor for the DNS server"
  default     = "m1.tiny"
}

variable "dns_userdata" {
  type        = string
  description = "path to userdata file"
  default     = null
}

variable "dns_userdata_vars" {
  type        = map(string)
  description = "variables for the userdata template"
  default = {
    external_dns = "8.8.8.8"
  }
}

variable "sshkey" {
  type        = string
  description = "ssh key for the DNS server"
  default     = "cyberrange-key"
}

variable "external_dns" {
  type        = list(string)
  description = "List of external DNS servers to configure for the internet network zone"
  default     = ["8.8.8.8"]
}
