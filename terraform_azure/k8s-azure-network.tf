# Create a master VM and X workers VM for a K8s cluster
# Thiago Melo - 2022
# https://github.com/reiserfs/k8s
#
resource "azurerm_network_security_group" "k8s_secutiry_group" {
  name                = "k8s_secutiry_group"
  location            = var.cluster_zone
  resource_group_name = var.resource_group

    security_rule {
      name                       = "ssh"
      priority                   = 300
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

}

resource "azurerm_virtual_network" "k8s_cluster" {
  name                = "k8s_cluster"
  location            = var.cluster_zone
  resource_group_name = var.resource_group
  address_space       = var.cidr_block

  tags = {
    environment = "k8snodes"
  }
}

resource "azurerm_subnet" "k8s_nodes" {
  name                 = "k8s_nodes"
  resource_group_name = var.resource_group
  virtual_network_name = azurerm_virtual_network.k8s_cluster.name
  address_prefixes     = var.subnet

}

resource "azurerm_public_ip" "master" {
  name                = "k8s-master"
  location            = var.cluster_zone
  resource_group_name = var.resource_group
  allocation_method   = "Dynamic"
  #depends_on          = [azurerm_linux_virtual_machine.master]
}

data "azurerm_public_ip" "master" {
  name                = "k8s-master"
  resource_group_name = var.resource_group
  depends_on          = [azurerm_public_ip.master]
}

resource "azurerm_public_ip" "workers" {
  count               = var.workers
  name                = "k8s-workers${count.index}"
  location            = var.cluster_zone
  resource_group_name = var.resource_group
  allocation_method   = "Dynamic"
  #depends_on          = [azurerm_linux_virtual_machine.workers]
}


output "k8s_master_ip" {
  value = azurerm_public_ip.master.ip_address
}
output "k8s_workers_ip" {
  value = azurerm_public_ip.workers[*].ip_address
}

resource "azurerm_network_interface" "k8s_nic_master" {
  name                = "k8s_nic_master"
  location            = var.cluster_zone
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.k8s_nodes.id
    private_ip_address_allocation = "Static"
    private_ip_address = "${var.prefix_netip}.10"
    public_ip_address_id          = azurerm_public_ip.master.id
  }
}


resource "azurerm_network_interface" "k8s_nic_workers" {
  count               = var.workers
  name                = "k8s_nic_workers${count.index}"
  location            = var.cluster_zone
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.k8s_nodes.id
    private_ip_address_allocation = "Static"
    private_ip_address = "${var.prefix_netip}.1${count.index+1}"
    public_ip_address_id          = azurerm_public_ip.workers[count.index].id
  }
}
