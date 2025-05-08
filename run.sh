#!/bin/bash
##############################################################################################
#  Copyright Accenture. All Rights Reserved.
#
#  SPDX-License-Identifier: Apache-2.0
##############################################################################################

set -e

echo "Starting build process..."

echo "Adding env variables..."
export PATH=/root/bin:$PATH

# Path to k8s config file
export KUBECONFIG=/home/bevel/build/config

echo "Validatin network yaml"
ajv validate -s /home/bevel/platforms/network-schema.json -d /home/bevel/build/network.yaml 

echo "Running the playbook..."
exec ansible-playbook -vv /home/bevel/platforms/shared/configuration/site.yaml --inventory-file=/home/bevel/platforms/shared/inventory/ -e "@/home/bevel/build/network.yaml" -e 'ansible_python_interpreter=/usr/bin/python3'
