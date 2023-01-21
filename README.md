# k8s
# Thiago Melo - 2022
#

Set up a K8s cluster using Terraform and Ansible

Terraform:
  - create a vpc network, subnetwork and firewall on google cloud for the K8s cluster
  - create a compute instance on google cloud for K8s master
  - create X computers instances on google cloud for K8s workers
  - Provision ansible invetory and run playbook

Terraform-Ansible-Inventory:
  - Python script to create ansible inventory using terraform tfstate file

Ansible:
 - Playbook to deploy a K8s cluster in the computers instances created in google cloud.
