variable location_name {
  type        = string
  description = "location name"
}

variable resourcegroup_name {
  type        = string
  description = "Name of the resource group"
}

variable network_id {
  type        = string
}

variable vm_machine_name {
  type        = string
}

variable "public_key_openssh" {
  type = string
}