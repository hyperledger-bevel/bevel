[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

## shared/configuration/roles/setup
This folder contains common roles required for setting up necessary requirements.
It contains following roles.
### Ambassador
This roles setups Ambassador.
#### Tasks Included
##### 1. Install Ambassador

This task deploys the ambassador helmchart from ```platforms/shared/charts/ambassador``` directory. Additional Ambassador ports can be opened by providing `network.env.ambassadorPorts` values in network.yaml.

##### 2. wait for pods to come up
This checks for the Ambassador Pods to come up.

------
### aws_auth
This role installs aws authenticator.
#### Tasks Included
#### 1. register temporary directory
It creates a temporary registory directory.

#### 2.  check aws-authenticator
It checks if aws-authenticator is present or not. It stores the result of the query in *aws_auth_stat_result*.

#### 3. Install aws-authenticator
This task installs the aws authenticator if the *aws_auth_stat_result* is false i.e. aws authenticator is not present.

#### 4. Test Kubernetes connection
It tests the Kubernetes connection, stores the result in *pods_default*.

-----

### aws-cli
This task install aws cli.

#### Tasks Included

#### 1. register temporary directory
This task creates a registory temporary directory. Stores the result in *tmp_directory*.

#### 2. check aws cli
This task checks if the aws cli is present or not. Stores the result in *aws_cli_stat_result*.

#### 3. download aws cli
If aws cli is not present i.e. *aws_cli_stat_result* is false, it downloads the aws cli.

#### 4. install unzip
If aws cli is not present i.e. *aws_cli_stat_result* is false, it downloads the unzip module.

#### 5. extract aws cli
This task extracts the aws cli. It runs only when aws cli is not present i.e.  *aws_cli_stat_result* is false.

#### 6. install aws cli
This task installs the aws cli as a root user.It runs only when aws cli is not present i.e.  *aws_cli_stat_result* is false.

#### 7. configuring aws
This task configures aws cli with *access_id* and *secret_key*.

----------------

### flux
#### Task Included

#### 1.  Check if Flux is running
This task checks whether the flux is running for the environment (network.env.type) . stores the result in *flux_service*

#### 2. Get ssh known hosts
It get the ssh hosts, runs only when flux service is not found.

#### 3. Helm repo add
It initializes the helm repo and adds flux, runs only when flux service is not found.

#### 4. Install flux
This task first creates the HelmRelease Custom resource, and then deploys Flux helmchart, runs only when flux service is not found.

#### 5. wait for pods to come up
This checks for the flux Pods to come up. It runs when *flux_service.resources* is not there i.e. flux is not found, until kubectl_get_pods gives a positive result.


-------------


### helm
This task installs helm.

#### Tasks Included

#### 1. register temporary directory
This task creates a registory temporary directory. Stores the result in *tmp_directory*.

#### 2. check helm
This task checks if helmi is present or not. Stores the result in *helm_stat_result*.

#### 3. Install helm
If helm is not present i.e. *helm_stat_result* is false, it downloads the helm using specified url.

#### 4. Unzip helm archive
This tasks unzips helm archive, runs only when helm is not found.

#### 5. Move helm binaries
This task moves helm binaries from specified source to destination. It runs only when helm is not present i.e. *helm_stat_result* is false.

#### 6. Test helm installation
This task tests helm installation.

----------------

### kubectl
This task installs kubectl.

#### Tasks Included

#### 1. register temporary directory
This task creates a registory temporary directory. Stores the result in *tmp_directory*.

#### 2. check kubectl
This task checks if kubectl is present or not. Stores the result in *kubectl_stat_result*.

#### 3. Download kubectl binary
If kubectl is not present i.e. *kubectl_stat_result* is false, it downloads the kubectl using specified url.

#### 4. Unarchive kubernetes-client
This tasks unzips kubernetes-client archive, runs only when kubectl is not found.

#### 5. Copy kubectl binary to destination directory
This task moves kubectl binaries from specified source to destination. It runs only when helm is not present i.e. *kubectl_stat_result* is false.

#### 6. Test kubectl installation
This task tests kubectl installation.

----------------

### vault
This task installs vault.

#### Tasks Included

#### 1. register temporary directory
This task creates a registory temporary directory. Stores the result in *tmp_directory*.

#### 2. check vault
This task checks if vault is present or not. Stores the result in *vault_stat_result*.

#### 3. Install vault client
If vault is not present i.e. *vault_stat_result* is false, it downloads the vault from specified url.

#### 4. Unzip vault archive
This tasks unzips vault archive to specified destination, runs only when vault is not found.

#### 5. Test vault installation
This task tests vault installation.
