variable "prefix_netip" {
  type = string
  default = "192.168.87"
}

variable "subnet" {
  type = string
  default = "192.168.87.0/24"
}

variable "cluster_zone" {
  type    = string
  default = "europe-west9-a"
}

variable "machine" {
  type    = string
  default = "e2-medium"
}

variable "ssh_username" {
  type    = string
  default = "thiago"
}

variable "workers" {
  type    = number
  default = 3
}
