# Create a master VM and X workers VM for a K8s cluster
# Thiago Melo - 2022
# https://github.com/reiserfs/k8s
#
resource "null_resource" "ansible_run" {
  provisioner "remote-exec" {
    inline = ["sudo yum -y update", "echo Done!"]
    connection {
      host        = azurerm_linux_virtual_machine.master.public_ip_address
      type        = "ssh"
      user        = "thiago"
      #private_key = file(var.pvt_key)
    }
  }

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "terraform-ansible-inventory --input terraform.tfstate --output ../ansible/inventory"
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/inventory -v ../ansible/k8scluster.yml"
  }
}
