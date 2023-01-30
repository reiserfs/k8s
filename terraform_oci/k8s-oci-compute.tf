resource "oci_core_instance" "master" {
  availability_domain = "SjFx:EU-MADRID-1-AD-1"
  compartment_id = var.compartment_id
  display_name   = "k8s-master"
  shape = "${var.machine}"
  shape_config {
		baseline_ocpu_utilization = "BASELINE_1_1"
		memory_in_gbs = "4"
		ocpus = "2"
	}

  create_vnic_details {
		assign_private_dns_record = "true"
		assign_public_ip = "true"
		subnet_id = oci_core_subnet.k8s_nodes.id
    private_ip = "${var.prefix_netip}.10"
	}

	source_details {
		source_id = "ocid1.image.oc1.eu-madrid-1.aaaaaaaa7wsuv4as6nzttbhq2qotmfvkyypzee2xa5ifqf6mt5dlzcsd3u5a"
		source_type = "image"
	}
  metadata = {
    thiago = "admin"
    ssh_authorized_keys = file("../thiago.pub")
  }

  depends_on = [
    oci_core_subnet.k8s_nodes
  ]
}

resource "oci_core_instance" "workers" {
  availability_domain = "SjFx:EU-MADRID-1-AD-1"
  count = var.workers
  compartment_id = var.compartment_id
  display_name   = "k8s-worker${count.index}"
  shape = "${var.machine}"
  shape_config {
		baseline_ocpu_utilization = "BASELINE_1_1"
		memory_in_gbs = "4"
		ocpus = "2"
	}

  create_vnic_details {
		assign_private_dns_record = "true"
		assign_public_ip = "true"
		subnet_id = oci_core_subnet.k8s_nodes.id
    private_ip = "${var.prefix_netip}.1${count.index+1}"
	}

	source_details {
		source_id = "ocid1.image.oc1.eu-madrid-1.aaaaaaaa7wsuv4as6nzttbhq2qotmfvkyypzee2xa5ifqf6mt5dlzcsd3u5a"
		source_type = "image"
	}
  metadata = {
    thiago = "admin"
    ssh_authorized_keys = file("../thiago.pub")
  }

  depends_on = [
    oci_core_subnet.k8s_nodes
  ]
}
