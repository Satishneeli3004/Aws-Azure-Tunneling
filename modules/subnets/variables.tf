variable resourcegroup_name {
  type        = string
  description = "Name of the resource group"
}

variable network_name {
  type        = string
  description = "Name of the resource group"
}

variable subnet_name {
    type =  string
    description =   "Name of the app subnet"
}

variable "subnet_range" {
  description = "Address prefixes for the subnet"
  type        = list(string)
}