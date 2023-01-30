resource "null_resource" "ansible_run" {
  provisioner "remote-exec" {
    inline = ["sudo yum -y update", "echo Done!"]
    connection {
      host        = oci_core_instance.master.public_ip
      type        = "ssh"
      user        = "${var.ssh_username}"
      #private_key = file(var.pvt_key)
    }
  }

  triggers = {
    always_run = "${timestamp()}"
  }
  
  provisioner "local-exec" {
    command = "terraform-ansible-inventory --file terraform.tfstate"
  }

   provisioner "local-exec" {
     command = "cat oci-ansible-inventory-user >>  ../ansible/inventory"
   }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/inventory -v ../ansible/k8scluster.yml"
  }
}
