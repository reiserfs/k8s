# Create a master VM and X workers VM for a K8s cluster
# Thiago Melo - 2022
# https://github.com/reiserfs/k8s
#
resource "azurerm_ssh_public_key" "k8s_ssh_key" {
  name                = "k8s_ssh_key"
  location              = var.cluster_zone
  resource_group_name   = var.resource_group
  public_key          = file("../thiago.pub")
}

resource "azurerm_linux_virtual_machine" "master" {
  name                  = "k8s-master"
  location              = var.cluster_zone
  resource_group_name   = var.resource_group
  size               = var.machine_type
  admin_username = "thiago"

  source_image_reference {
    publisher = "Oracle"
    offer     = "Oracle-Linux"
    sku       = "ol85-lvm-gen2"
    version   = "latest"
  }

  network_interface_ids = [
    azurerm_network_interface.k8s_nic_master.id,
  ]

  admin_ssh_key {
       username = "thiago"
       public_key =  azurerm_ssh_public_key.k8s_ssh_key.public_key
   }

   os_disk {
     caching              = "ReadWrite"
     storage_account_type = "Standard_LRS"
   }
}

resource "azurerm_linux_virtual_machine" "workers" {
  name                  = "k8s-worker${count.index}"
  count = var.workers
  location              = var.cluster_zone
  resource_group_name   = var.resource_group
  size               = var.machine_type
  admin_username = "thiago"

  source_image_reference {
    publisher = "Oracle"
    offer     = "Oracle-Linux"
    sku       = "ol85-lvm-gen2"
    version   = "latest"
  }

  network_interface_ids = [
    azurerm_network_interface.k8s_nic_workers[count.index].id,
  ]

  admin_ssh_key {
       username = "thiago"
       public_key =  azurerm_ssh_public_key.k8s_ssh_key.public_key
   }

   os_disk {
     caching              = "ReadWrite"
     storage_account_type = "Standard_LRS"
   }
}
