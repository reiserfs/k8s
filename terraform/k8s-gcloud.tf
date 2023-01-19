resource "google_compute_instance" "masterk8s" {
  name         = "k8s-master"
  machine_type = "e2-micro"
  zone = "europe-west9-a"

  tags = ["k8s-cluster","master-node","controller"]

  boot_disk {
    initialize_params {
      image = "rocky-linux-cloud/rocky-linux-8-optimized-gcp"
    }
  }

  network_interface {
    subnetwork = "k8s-nodes"
    network_ip = "192.168.87.10"
    access_config {
    }
  }

  metadata = {
    ssh-keys = "thiago:${file("thiago.pub")}"
  }

  service_account {
    scopes = ["compute-rw","storage-ro","service-management","service-control","logging-write","monitoring"]
  }
}

resource "google_compute_instance" "workerk8s" {
  name         = "km-worker-${count.index}"
  machine_type = "e2-micro"
  zone = "europe-west9-a"
  count = 3

  tags = ["k8s-cluster","master-node","controller"]

  boot_disk {
    initialize_params {
      image = "rocky-linux-cloud/rocky-linux-8-optimized-gcp"
    }
  }

  network_interface {
    subnetwork = "k8s-nodes"
    network_ip = "192.168.87.1${count.index+1}"
    access_config {
    }
  }

  metadata = {
    ssh-keys = "thiago:${file("thiago.pub")}"
  }

  service_account {
    scopes = ["compute-rw","storage-ro","service-management","service-control","logging-write","monitoring"]
  }
}
