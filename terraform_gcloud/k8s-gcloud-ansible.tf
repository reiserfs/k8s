# Create a master VM and X workers VM for a K8s cluster
# Thiago Melo - 2022
# https://github.com/reiserfs/k8s
#

resource "null_resource" "ansible_run" {
  provisioner "remote-exec" {
    inline = ["sudo yum -y update", "echo Done!"]
    connection {
      host        = google_compute_instance.master.network_interface[0].access_config[0].nat_ip
      type        = "ssh"
      user        = "${var.ssh_username}"
      #private_key = file(var.pvt_key)
    }
  }

  provisioner "local-exec" {
    command = "terraform-ansible-inventory --file terraform.tfstate"
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/inventory -v ../ansible/k8scluster.yml"
  }
}
