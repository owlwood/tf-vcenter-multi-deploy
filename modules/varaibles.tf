# vCenter Details
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {}
variable "vsphere_datacenter" {}
variable "vsphere_datastore" {}
variable "vsphere_compute_cluster" {}
variable "vsphere_network" {}

# Global Variables
variable "unique_identifier_prefix" {}
variable "vmdns1" {}
variable "vmdns2" {}
variable "create_timeout" {}
variable "delete_timeout" {}
variable "linked_clone" {}

# Managers configure
variable "manager_instance_count" {}
variable "manager_template_name" {}
variable "manager_name" {}
variable "manager_root_user" {}
variable "manager_root_password" {}
variable "manager_cpu" {}
variable "manager_mem_mb" {}
#variable "manager_disk_size" {}
variable "manager_bios_type" {}
variable "manager_bootstrap_script" {}
variable "manager_ip_prefix" {}
variable "manager_ip_start" {}
variable "manager_ipv4_gateway" {}
variable "manager_domain" {}

# Workers configure
variable "worker_instance_count" {}
variable "worker_template_name" {}
variable "worker_name" {}
variable "worker_root_user" {}
variable "worker_root_password" {}
variable "worker_cpu" {}
variable "worker_mem_mb" {}
#variable "worker_disk_size" {}
variable "worker_bios_type" {}
variable "worker_bootstrap_script" {}
variable "worker_ip_prefix" {}
variable "worker_ip_start" {}
variable "worker_ipv4_gateway" {}
variable "worker_domain" {}

# Random Name Generator
resource "random_pet" "unique_identifier" {
  prefix = "${var.unique_identifier_prefix}"
  separator = "-"
  length = "1"
}
