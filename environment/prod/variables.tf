variable "location_name" {
  type        = string
  description = "location name"
}

variable "resourcegroup_name" {
  type        = string
  description = "Name of the resource group"
}

variable "network_name" {
  type        = string
  description = "Name of the resource group"
}

variable "bastion_subnet_name" {
  type        = string
  description = "Name of the app subnet"
}

variable "bastion_subnet_range" {
  description = "Address prefixes for the subnet"
  type        = list(string)
}

variable "web_subnet_name" {
  type        = string
  description = "Name of the app subnet"
}

variable "web_subnet_range" {
  description = "Address prefixes for the subnet"
  type        = list(string)
}

variable "app_subnet_name" {
  type        = string
  description = "Name of the app subnet"
}

variable "app_subnet_range" {
  description = "Address prefixes for the subnet"
  type        = list(string)
}

variable "dbsubnet_name" {
  type        = string
  description = "Name of the app subnet"
}

variable "dbsubnet_range" {
  description = "Address prefixes for the subnet"
  type        = list(string)
}

# variable "subnet_range" {
#   description = "Address prefixes for the subnet"
#   type        = list(string)
# }

variable "nat_name" {
  type        = string
  description = "description"
}

variable "nat_public_ip_name" {
  type        = string
  description = "Name of the resource group"
}
# variable "network_interface_name" {
#   type        = string
#   description = "Name of the resource group"
# }

variable "bastion_interface_name" {
  type        = string
  description = "Name of the resource group"
}

variable "web_interface_name" {
  type        = string
  description = "Name of the resource group"
}

variable "app_interface_name" {
  type        = string
  description = "Name of the resource group"
}

variable "db_interface_name" {
  type        = string
  description = "Name of the resource group"
}

# variable "network_id" {
#   type = string
# }

variable "vm_machine_name" {
  type = string
}

variable "ubuntu_vm_publicIp_name" {
  type        = string
  description = "Name of the resource group"
}


