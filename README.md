# k8s

Set up a K8s cluster using Terraform and Ansible

Terraform:
  - create a vpc network, subnetwork and firewall on google cloud for the K8s cluster
  - create a compute instance on google cloud for K8s master
  - create X computers instances on google cloud for K8s workers

Terraform-Ansible-Inventory:
  - Python script to create inventory using terraform state output in json

Ansible:
 - Playbook to deploy a K8s cluster in the computers instances created in google cloud.
