# Create a master VM and X workers VM for a K8s cluster
# Thiago Melo - 2022
# https://github.com/reiserfs/k8s
#
provider "oci" {
  user_ocid = ${var.user_ocid}
  fingerprint = ${var.fingerprint}
  tenancy_ocid = ${var.tenancy_ocid}
  region  = ${var.cluster_zone}
  private_key_path = ${var.private_key_path}
}

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.0.0"
    }
  }
}
