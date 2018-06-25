module "lab1-instances" {
  source = "./modules"

# vCenter Details
  vsphere_user		    	    = "administrator@vsphere.local"
  vsphere_password		      = "VMware1!"
  vsphere_server			      = "10.0.102.5"
  vsphere_datacenter        = "mydatacenter_name"
  vsphere_datastore         = "mydatastore"
  vsphere_compute_cluster   = "mycluster"
  vsphere_network           = "mynetwork"

  # Global Variables
  unique_identifier_prefix  = "r" # prefix for random name generator, currently disabled
  vmdns1                    = "8.8.8.8"
  vmdns2                    = "8.8.4.4"
  create_timeout            = "20m" #WIP
  delete_timeout            = "5m" #WIP
  linked_clone              = true

# Managers configure
manager_instance_count	  = "3" #if you only need a single instance type set workers to 0 below
manager_template_name     = "centos7-template"
manager_name			        = "g-manager" # instance names will end with instancecount #does not like "_"
manager_root_user         = "root" # admin for ubuntu
manager_root_password     = "VMware1!"
manager_cpu               = "2"
manager_mem_mb            = "2048"
#manager_disk_size         = "60" #size in GB, cannot be used for linked clones
manager_bios_type         = "bios" #efi for Photon, bios for most others
manager_bootstrap_script  = "bootstrapopenshift.sh" #need to add a local exec options for ansible scripts
manager_ip_prefix		      = "10.0.102."
manager_ip_start          = "70"
manager_ipv4_gateway      = "10.0.102.1"
manager_domain            = "home.lab"

# Workers configure
worker_instance_count	    = "2" #Set to 0 if you don't need any workers
worker_template_name      = "centos7-template" # options are centos7, ubuntu18, photon-full, photon-minimal
worker_name				        = "g-worker" # instance names will end with instance_count
worker_root_user          = "root" # admin for ubuntu18
worker_root_password      = "VMware1!" # default is "VMware1!" for most, photon required stronger so "ESX4peeps!"
worker_cpu                = "2"
worker_mem_mb             = "4096"
#worker_disk_size          = "60" #size in GB
worker_bios_type          = "bios" #efi for Photon, bios for most others
worker_bootstrap_script   = "bootstrapopenshift.sh"
worker_ip_prefix		      = "10.0.102."
worker_ip_start          = "80"
worker_ipv4_gateway       = "10.0.102.1"
worker_domain             = "home.lab"
}
