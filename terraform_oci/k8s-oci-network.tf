resource "oci_core_vcn" "k8s_cluster" {
    compartment_id = var.compartment_id
    cidr_block = var.cidr_block
    display_name = "k8s_cluster"
    dns_label = "k8scluster"
    is_ipv6enabled = false
}

resource "oci_core_subnet" "k8s_nodes" {
    #Required
    display_name = "k8s_nodes"
    dns_label = "k8scluster"
    cidr_block = var.subnet
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.k8s_cluster.id
    depends_on = [
      oci_core_vcn.k8s_cluster
    ]
    security_list_ids = [oci_core_security_list.k8s_cluster_allow_internal.id,oci_core_security_list.k8s_cluster_allow_external.id]
}

resource "oci_core_security_list" "k8s_cluster_allow_internal" {
    #Required
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.k8s_cluster.id
    display_name = "k8s_cluster_allow_internal"
    egress_security_rules {
        #Required
        destination = var.subnet
        protocol = "all"
    }
    ingress_security_rules {
        #Required
        protocol = "all"
        source = var.subnet
    }
    depends_on = [
      oci_core_vcn.k8s_cluster
    ]
}

resource "oci_core_security_list" "k8s_cluster_allow_external" {
    #Required
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.k8s_cluster.id
    display_name = "k8s_cluster_allow_external"
    egress_security_rules {
        #Required
        destination = var.subnet
        protocol = "all"
    }
    ingress_security_rules {
        #Required
        protocol = 6
        source = "0.0.0.0/0"
        tcp_options {
            #Optional
            max = 22
            min = 22
        }
    }
    depends_on = [
      oci_core_vcn.k8s_cluster
    ]
}
