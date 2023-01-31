# Create a master VM and X workers VM for a K8s cluster
# Thiago Melo - 2022
# https://github.com/reiserfs/k8s
#
provider "google" {
  project = "k8s-training-375110"
  region  = "europe-west9"
  zone    = "europe-west9-a"
  credentials = file("gcloud.json")
}
