#!/bin/sh

# Enable debug logging
# Uncomment to log to file instead of console.
# export TF_LOG_PATH=./terraform_test.log
export OS_DEBUG=1
export TF_LOG=DEBUG

terraform apply -auto-approve
