#!/bin/bash

# Cleanup Docker key from cloned templates and verify dependancies

#systemctl stop docker
#rm -rf /etc/docker/key.json
sudo yum install -y docker
systemctl start docker
systemctl enable docker
yum install -y wget tar
