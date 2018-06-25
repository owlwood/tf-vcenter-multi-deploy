#!/usr/bin/env bash
# WIP for module
# Run this before running terraform commands run using ". tf-openrc.sh"
# comment out the lines in your instances.tf file where these are set
echo "Please enter your vcenter Password: "
read -rs OS_VSPHERE_PASSWORD_INPUT
export TF_VAR_vsphere_password=$OS_VSPHERE_PASSWORD_INPUT

echo "Please enter your manager root Password: "
read -rs OS_MANAGER_PASSWORD_INPUT
export TF_VAR_manager_root_password=$OS_MANAGER_PASSWORD_INPUT

echo "Please enter your worker root Password: "
read -rs OS_WORKER_PASSWORD_INPUT
export TF_VAR_worker_root_password=$OS_WORKER_PASSWORD_INPUT
