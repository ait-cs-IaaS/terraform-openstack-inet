variable "internet_cidr" {
  type = string
  default = "240.64.0.0/10"
}

variable "public_router_name" { type = string }

variable "create_dns" {
  type = bool
  default = true
}

variable "dns_image" {
  type = string
  default = ""
}

variable "dns_flavor" {
  type = string
  default = ""
}