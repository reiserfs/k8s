# Create a master VM and X workers VM for a K8s cluster
# Thiago Melo - 2022
# https://github.com/reiserfs/k8s
#

resource "google_compute_instance" "master" {
  name         = "k8s-master"
  machine_type = "${var.machine}"
  zone = "${var.cluster_zone}"
  allow_stopping_for_update = true
  tags = ["k8s-cluster","master-node","controller"]

  boot_disk {
    initialize_params {
      image = "rocky-linux-cloud/rocky-linux-8-optimized-gcp"
    }
  }

  network_interface {
    subnetwork = "k8s-nodes"
    network_ip = "${var.prefix_netip}.10"
    access_config {
    }
  }

  metadata = {
    ssh-keys = "thiago:${file("../thiago.pub")}"
  }

  service_account {
    scopes = ["compute-rw","storage-ro","service-management","service-control","logging-write","monitoring"]
  }
  depends_on = [
    google_compute_subnetwork.k8s-nodes
  ]
}

resource "google_compute_instance" "workers" {
  name         = "k8s-worker${count.index}"
  machine_type = "${var.machine}"
  zone = "europe-west9-a"
  allow_stopping_for_update = true
  count = var.workers

  tags = ["k8s-cluster","master-node","controller"]

  boot_disk {
    initialize_params {
      image = "rocky-linux-cloud/rocky-linux-8-optimized-gcp"
    }
  }

  network_interface {
    subnetwork = "k8s-nodes"
    network_ip = "${var.prefix_netip}.1${count.index+1}"
    access_config {
    }
  }

  metadata = {
    ssh-keys = "thiago:${file("../thiago.pub")}"
  }

  service_account {
    scopes = ["compute-rw","storage-ro","service-management","service-control","logging-write","monitoring"]
  }
  depends_on = [
    google_compute_subnetwork.k8s-nodes
  ]
}
