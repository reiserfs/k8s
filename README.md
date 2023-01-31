# K8s
## Create a K8s cluster with a master and X workers using cloud computers on gcloud, oci, azure and aws
- Thiago Melo - 2022
- https://github.com/reiserfs/k8s


Set up a K8s cluster using Terraform and Ansible

Supports Google Cloud (gcloud), Oracle Cloud (oci), Microsoft Azure, (TBA) Amazon AWS

Terraform:
  - create a vpc network, subnetwork and firewall on cloud for the K8s cluster
  - create a compute instance on cloud for K8s master
  - create X computers instances on cloud for K8s workers
  - Provision ansible inventory and run playbook
  - There is a folder for each cloud.

Terraform-Ansible-Inventory:
  - Python script to create ansible inventory using terraform tfstate file

Ansible:
 - Playbook to deploy a K8s cluster in the computers instances created in google cloud.


 How to:
  1. Access the folder of the cloud you want to create the cluster (ex: terraform_gcloud)
  2. Change the variables
  3. Run terraform plan
  4. Run terraform apply

  Requirements.
  1. For Azure you need az cli installed on your machine.
  2. For Oracle you do not need oci cli installed but it is helpful to have it for debug.
  3. For Google Cloud credentials you need to create a file terraform_gcloud/gcloud.json and put the data from gcloud cli
  4. For Oracle credentials create a file terraform_oci/credentials.tf and create the variables used on providers.tf
  5. For Azure credentials create a file terraorm_azure/credentials.tf and create the variables used on providers.tf
  6. Still for azure you need to type #az login before apply a plan.
