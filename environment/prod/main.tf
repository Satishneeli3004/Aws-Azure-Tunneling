module "resource_group" {
  source             = "../../modules/ResourceGroup/"
  location_name      = var.location_name
  resourcegroup_name = var.resourcegroup_name
}

module "virtual_network" {
  source             = "../../modules/vnet"
  resourcegroup_name = module.resource_group.name
  location_name      = var.location_name
  network_name       = var.network_name
}

module "appsubnet" {
  source             = "../../modules/subnets"
  resourcegroup_name = module.resource_group.name
  network_name       = module.virtual_network.name
  subnet_name        = var.subnet_name
  subnet_range       = var.subnet_range
}

module "dbsubnet" {
  source             = "../../modules/subnets"
  resourcegroup_name = module.resource_group.name
  network_name       = module.virtual_network.name
  subnet_name        = var.Dbsubnet_name
  subnet_range       = var.Dbsubnet_range
}

module "nat" {
  source             = "../../modules/nat"
  resourcegroup_name = module.resource_group.name
  location_name      = var.location_name
  nat_name           = var.nat_name
}

resource "azurerm_subnet_nat_gateway_association" "appsubnet_associate" {
  subnet_id      = module.appsubnet.subnet_id
  nat_gateway_id = module.nat.nat_gateway_id
}


module "Public_nat_ip" {
  source             = "../../modules/nat-pip"
  nat_public_ip_name = var.nat_public_ip_name
  location_name      = var.location_name
  resourcegroup_name = var.resourcegroup_name
}

resource "azurerm_nat_gateway_public_ip_association" "public_ip_assoication_to_nat" {
  nat_gateway_id       = module.nat.nat_gateway_id
  public_ip_address_id = module.Public_nat_ip.nat_public_ip_UAT
}

module "Public_vm_Ip" {
  source                  = "../../modules/vm-pip"
  ubuntu_vm_publicIp_name = var.ubuntu_vm_publicIp_name
  location_name           = var.location_name
  resourcegroup_name      = var.resourcegroup_name
}

module "network_interface" {
  source                 = "../../modules/network-interface"
  network_interface_name = var.network_interface_name
  location_name          = var.location_name
  resourcegroup_name     = var.resourcegroup_name
  subnet_id              = module.appsubnet.subnet_id
  public_ip_id           = module.Public_vm_Ip.vm_public_ip

}

module "ssh_key" {
  source = "../../modules/tls"
}

module "webserver" {
  source             = "../../modules/vm"
  vm_machine_name    = var.vm_machine_name
  location_name      = var.location_name
  resourcegroup_name = var.resourcegroup_name
  network_id         = module.network_interface.network_interface_id

  public_key_openssh = module.ssh_key.public_key_openssh
}

