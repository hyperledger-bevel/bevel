[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Roles

## Overview
This folder contains the roles or modules which are common to all the DLT platforms. All these roles are called from the playbooks and these roles cannot be executed from this folder.
Please follow the readme in [**configuration**](../README.md) directory for help on how to execute the playbooks.

## Roles description ##

### git_push ###
- This role is used to do a git-commit whenever the configuration has to check-in the generated helm-value files. The role takes the git parameters as input.

### helm_lint
- This role runs a ``helm lint`` to check for the syntax validity of the generated helm values against the helm charts. This role should be called before doing a *git_push* for a helm value file.

### setup ###
- This folder groups all the **setup** roles
#### ambassador
- This role deploys the Ambassador helm chart on the provided cluster. If already deployed, this role skips the redeployment. To force redeployment, please delete the ambassador helm release from the cluster.
#### aws-auth
- This role installs aws-authenticator which is required to connect to the EKS Kubernetes cluster. This role is called only if the network.yaml has ``organization.cloud_provider: aws``. 
#### aws-cli
- This role installs aws-cli which is required to connect to the EKS Kubernetes cluster. This role is called only if the network.yaml has ``organization.cloud_provider: aws``.
#### flux
- This role deploys the Flux helm chart on the provided cluster. If already deployed, this role skips the redeployment. It provides the SSH public key as output which needs to be added as a read-write key to the git repository so that Flux can sync with the repo. To force redeployment, please delete the flux helm release from the cluster. 
#### helm
- This role installs helm client which is required to deploy helm charts on the Kubernetes cluster. ``helm`` is mandatory to be installed on the Ansible controller.
#### kubectl
- This role installs kubectl which is required to connect to the any Kubernetes cluster. ``kubectl`` is mandatory to be installed on the Ansible controller.
#### vault
- This role installs vault client which is required to connect to the HashiCorp Vault server. ``vault`` is mandatory to be installed on the Ansible controller.
