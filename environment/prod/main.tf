module "resource_group" {
  source             = "./modules/ResourceGroup/"
  location_name      = var.location_name
  resourcegroup_name = var.resourcegroup_name
}

module "virtual_network" {
  source             = "./modules/vnet"
  resourcegroup_name = module.resource_group.name
  location_name      = var.location_name
  network_name       = var.network_name
}

module "appsubnet" {
  source             = "./modules/subnets"
  resourcegroup_name = module.resource_group.name
  network_name       = module.virtual_network.name
  subnet_name        = var.subnet_name
}