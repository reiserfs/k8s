provider "google" {
  project = "k8s-training-375110"
  region  = "europe-west9"
  zone    = "europe-west9-a"
  credentials = file("gcloud.json")
}
