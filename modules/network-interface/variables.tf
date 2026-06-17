variable location_name {
  type        = string
  description = "location name"
}

variable resourcegroup_name {
  type        = string
  description = "Name of the resource group"
}

variable network_interface_name {
  type        = string
  description = "Provide the network interface name"
}


variable subnet_id {
  type        = string
  description = "provide the subnet_id"
}

variable "public_ip_id" {
  type = string
}