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

module "bastion_subnet" {
  source             = "../../modules/subnets"
  resourcegroup_name = module.resource_group.name
  network_name       = module.virtual_network.name
  subnet_name        = var.bastion_subnet_name
  subnet_range       = var.bastion_subnet_range
}

module "web_subnet" {
  source             = "../../modules/subnets"
  resourcegroup_name = module.resource_group.name
  network_name       = module.virtual_network.name
  subnet_name        = var.web_subnet_name
  subnet_range       = var.web_subnet_range
}

module "appsubnet" {
  source             = "../../modules/subnets"
  resourcegroup_name = module.resource_group.name
  network_name       = module.virtual_network.name
  subnet_name        = var.app_subnet_name
  subnet_range       = var.app_subnet_range
}

module "dbsubnet" {
  source             = "../../modules/subnets"
  resourcegroup_name = module.resource_group.name
  network_name       = module.virtual_network.name
  subnet_name        = var.dbsubnet_name
  subnet_range       = var.dbsubnet_range
}


module "nat" {
  source             = "../../modules/nat"
  resourcegroup_name = module.resource_group.name
  location_name      = var.location_name
  nat_name           = var.nat_name
}

# resource "azurerm_subnet_nat_gateway_association" "bastion_subnet_association" {
#   subnet_id      = module.bastion_subnet.subnet_id
#   nat_gateway_id = module.nat.nat_gateway_id
# }

resource "azurerm_subnet_nat_gateway_association" "app_subnet_association" {
  subnet_id      = module.appsubnet.subnet_id
  nat_gateway_id = module.nat.nat_gateway_id
}

resource "azurerm_subnet_nat_gateway_association" "web_subnet_association" {
  subnet_id      = module.web_subnet.subnet_id
  nat_gateway_id = module.nat.nat_gateway_id
}

module "Public_nat_ip" {
  source             = "../../modules/nat-pip"
  nat_public_ip_name = var.nat_public_ip_name
  location_name      = var.location_name
  # resourcegroup_name = var.resourcegroup_name
  resourcegroup_name = module.resource_group.name
}

resource "azurerm_nat_gateway_public_ip_association" "public_ip_assoication_to_nat" {
  nat_gateway_id       = module.nat.nat_gateway_id
  public_ip_address_id = module.Public_nat_ip.nat_public_ip_UAT
}

module "Public_vm_Ip" {
  source                  = "../../modules/vm-pip"
  ubuntu_vm_publicIp_name = var.ubuntu_vm_publicIp_name
  location_name           = var.location_name
  # resourcegroup_name      = var.resourcegroup_name
  resourcegroup_name = module.resource_group.name
}

module "bastion_network_interface" {
  source                 = "../../modules/network-interface"
  network_interface_name = var.bastion_interface_name
  location_name          = var.location_name
  resourcegroup_name     = var.resourcegroup_name
  subnet_id              = module.bastion_subnet.subnet_id
  public_ip_id           = module.Public_vm_Ip.vm_public_ip
}

module "web_network_interface" {
  source                 = "../../modules/network-interface"
  network_interface_name = var.web_interface_name
  location_name          = var.location_name
  resourcegroup_name     = var.resourcegroup_name
  subnet_id              = module.web_subnet.subnet_id
  public_ip_id           = null
}

module "app_network_interface" {
  source                 = "../../modules/network-interface"
  network_interface_name = var.app_interface_name
  location_name          = var.location_name
  resourcegroup_name     = var.resourcegroup_name
  subnet_id              = module.appsubnet.subnet_id
  public_ip_id           = null
}

module "db_network_interface" {
  source                 = "../../modules/network-interface"
  network_interface_name = var.db_interface_name
  location_name          = var.location_name
  resourcegroup_name     = var.resourcegroup_name
  subnet_id              = module.dbsubnet.subnet_id
  public_ip_id           = null
}

module "ssh_key" {
  source = "../../modules/tls"
}

module "bastion_server" {
  source             = "../../modules/vm"
  vm_machine_name    = "bastion-server"
  location_name      = var.location_name
  resourcegroup_name = var.resourcegroup_name
  network_id         = module.bastion_network_interface.network_interface_id

  public_key_openssh = module.ssh_key.public_key_openssh
}

module "webserver" {
  source             = "../../modules/vm"
  vm_machine_name    = var.vm_machine_name
  location_name      = var.location_name
  resourcegroup_name = var.resourcegroup_name
  network_id         = module.web_network_interface.network_interface_id

  public_key_openssh = module.ssh_key.public_key_openssh
}

