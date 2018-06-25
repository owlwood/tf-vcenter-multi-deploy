#!/bin/bash

# Cleanup Docker key from cloned templates
# verify dependancies and configure insecure docker daemon
# yum install docker-1.13.1, might need an older version of docker
sudo systemctl stop docker
sudo rm -rf /etc/docker/key.json
sudo rm -rf /etc/docker/daemon.json
sudo cat <<'EOF' > /etc/docker/daemon.json
{
  "insecure-registries": [
    "172.30.0.0/16"
  ]
}
EOF
sudo systemctl start docker
sudo systemctl enable docker
systemctl is-active docker
sudo systemctl daemon-reload
sudo yum install -y wget tar


sudo systemctl restart docker

yum erase kubectl-1.10.3-0.x86_64 -y
yum install -y centos-release-openshift-origin
yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion origin-clients

docker run -d --name "origin" --privileged --pid=host --net=host -v /:/rootfs:ro -v /var/run:/var/run:rw -v /sys:/sys -v /var/lib/docker:/var/lib/docker:rw -v /var/lib/origin/openshift.local.volumes:/var/lib/origin/openshift.local.volumes registry.centos.org/openshift/origin start

-------
yum install -y wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct
yum update -y
systemctl reboot
