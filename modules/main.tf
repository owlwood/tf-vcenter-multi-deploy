provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

provider "random" {
version = "=1.1.0"
}

data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vsphere_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vsphere_compute_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vsphere_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "manager-template" {
  name          = "${var.manager_template_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "worker-template" {
  name          = "${var.worker_template_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "Managers" {
  count          = "${var.manager_instance_count}"
  #name           = "${random_pet.unique_identifier.id}${var.manager_name}${count.index}"
  name           = "${var.manager_name}${count.index}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  firmware		   = "${var.manager_bios_type}"

  num_cpus = "${var.manager_cpu}"
  memory   = "${var.manager_mem_mb}"
  wait_for_guest_net_timeout = 0
  guest_id = "${data.vsphere_virtual_machine.manager-template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.manager-template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.manager-template.network_interface_types[0]}"
  }

  disk {
    label             = "disk0.vmdk"
    #size             = "${var.manager_disk_size}"
    size             = "${data.vsphere_virtual_machine.manager-template.disks.0.size}"
    #eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.manager-template.disks.0.thin_provisioned}"
}

  clone {
    template_uuid = "${data.vsphere_virtual_machine.manager-template.id}"

    customize {
      linux_options {
        host_name = "${var.manager_name}${count.index}"
        domain     = "${var.manager_domain}"
      }

	  network_interface {
		ipv4_address = "${var.manager_ip_prefix}${var.manager_ip_start + count.index}"
    ipv4_netmask = 24
      }
	  ipv4_gateway = "${var.manager_ipv4_gateway}"
    dns_server_list = ["${var.vmdns1}", "${var.vmdns2}"]
        }
    linked_clone = "${var.linked_clone}"
    }
    #timeouts {
    #create = "${var.create_timeout}"
    #delete = "${var.delete_timeout}"
  #}
}

resource "null_resource" "Managers" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers {
    Managers_instance_ids = "${join(",", vsphere_virtual_machine.Managers.*.id)}"
  }
  #user_data = "${file(${var.manager_bootstrap_script})}" #if cloud init, use this instead of remote-exec
  count        = "${var.manager_instance_count}"
  provisioner "remote-exec" {
      script= "${var.manager_bootstrap_script}"

      connection {
      host     = "${var.manager_ip_prefix}${var.manager_ip_start + count.index}"
      type     = "ssh"
      user     = "${var.manager_root_user}"
      password = "${var.manager_root_password}"
      agent    = "false"
      script_path = "/tmp/${var.manager_bootstrap_script}"
      }
  }
}

resource "vsphere_virtual_machine" "Workers" {
  count          = "${var.worker_instance_count}"
  #name           = "${random_pet.unique_identifier.id}_${var.worker_name}_${count.index}"
  name           = "${var.worker_name}${count.index}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  firmware		   = "${var.worker_bios_type}"

  num_cpus = "${var.worker_cpu}"
  memory   = "${var.worker_mem_mb}"
  wait_for_guest_net_timeout = 0
  guest_id = "${data.vsphere_virtual_machine.worker-template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.worker-template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.worker-template.network_interface_types[0]}"
  }

  disk {
    label             = "disk0.vmdk"
    #size             = "${var.worker_disk_size}"
    size             = "${data.vsphere_virtual_machine.worker-template.disks.0.size}"
    #eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.worker-template.disks.0.thin_provisioned}"
}

  clone {
    template_uuid = "${data.vsphere_virtual_machine.worker-template.id}"

    customize {
      linux_options {
        host_name = "${var.worker_name}${count.index}"
        domain     = "${var.worker_domain}"
      }

      network_interface {
  		ipv4_address = "${var.worker_ip_prefix}${var.worker_ip_start + count.index}"
          ipv4_netmask = 24
        }
  	  ipv4_gateway = "${var.worker_ipv4_gateway}"
      dns_server_list = ["${var.vmdns1}", "${var.vmdns2}"]
	    }
      linked_clone = "${var.linked_clone}"
   }
   #timeouts {
   #create = "${var.create_timeout}"
   #delete = "${var.delete_timeout}"
  #}
}

resource "null_resource" "Workers" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers {
    Workers_instance_ids = "${join(",", vsphere_virtual_machine.Workers.*.id)}"
  }
  #user_data = "${file(${var.worker_bootstrap_script})}" #if cloud init, use this instead of remote-exec
  count        = "${var.worker_instance_count}"
  provisioner "remote-exec" {
      script= "${var.worker_bootstrap_script}"

      connection {
      host     = "${var.worker_ip_prefix}${var.worker_ip_start + count.index}"
      type     = "ssh"
      user     = "${var.worker_root_user}"
      password = "${var.worker_root_password}"
      agent    = "false"
      script_path = "/tmp/${var.worker_bootstrap_script}"
      }
  }
}
