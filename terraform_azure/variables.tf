# Create a master VM and X workers VM for a K8s cluster
# Thiago Melo - 2022
# https://github.com/reiserfs/k8s
#
variable "prefix_netip" {
  type = string
  default = "192.168.87"
}

variable "cidr_block" {
  type        = list(string)
  default = ["192.168.0.0/16"]
}

variable "subnet" {
  type = list(string)
  default = ["192.168.87.0/24"]
}

variable "cluster_zone" {
  type    = string
  default = "switzerlandnorth"
}

variable "resource_group" {
  type    = string
  default = "k8s"
}

variable "machine_type" {
  type    = string
  default = "Standard_B2s"
}

variable "workers" {
  type    = number
  default = 1
}
