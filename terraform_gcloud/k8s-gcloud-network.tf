resource "google_compute_network" "k8s-cluster" {
  name         = "k8s-cluster"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "k8s-nodes" {
  name         = "k8s-nodes"
  ip_cidr_range = "${var.subnet}"
  network       = "k8s-cluster"
  depends_on = [
    google_compute_network.k8s-cluster
  ]
}

output "public_ip" {
  value = google_compute_instance.master.network_interface[0].access_config[0].nat_ip
}
