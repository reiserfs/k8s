#gcloud config set project k8s-training-375110
#gcloud config set compute/zone europe-west9-a
#gcloud compute networks create k8s-cluster --subnet-mode custom
#gcloud compute networks subnets create k8s-nodes --network k8s-cluster --range 192.168.87.0/24
#gcloud compute firewall-rules create k8s-cluster-allow-internal --allow tcp,udp,icmp,ipip --network k8s-cluster --source-ranges 192.168.87.0/24
#gcloud compute firewall-rules create k8s-cluster-allow-external --allow tcp:22,tcp:6443,icmp --network k8s-cluster --source-ranges 0.0.0.0/0

resource "google_compute_network" "k8s-cluster" {
  name         = "k8s-cluster"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "k8s-nodes" {
  name         = "k8s-nodes"
  ip_cidr_range = "${var.subnet}"
  network       = "k8s-cluster"
}

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
    ssh-keys = "thiago:${file("thiago.pub")}"
  }

  service_account {
    scopes = ["compute-rw","storage-ro","service-management","service-control","logging-write","monitoring"]
  }
}

resource "google_compute_instance" "workers" {
  name         = "k8s-worker${count.index}"
  machine_type = "${var.machine}"
  zone = "europe-west9-a"
  allow_stopping_for_update = true
  count = 3

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
    ssh-keys = "thiago:${file("thiago.pub")}"
  }

  service_account {
    scopes = ["compute-rw","storage-ro","service-management","service-control","logging-write","monitoring"]
  }
}

resource "google_compute_firewall" "k8s-cluster-allow-internal" {
  name         = "k8s-cluster-allow-internal"
  source_ranges = ["${var.subnet}"]
  network       = "k8s-cluster"
  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "k8s-cluster-allow-external" {
  name         = "k8s-cluster-allow-external"
  source_ranges = ["0.0.0.0/0"]
  network       = "k8s-cluster"
  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "6443"]
  }
}
