[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "install-chaincode-hyperledger-fabric-deployment"></a>
# Install Chaincode Hyperledger Fabric Deployment

- [Install Chaincode Hyperledger Fabric Deployment Helm Chart](#install-chaincode-hyperledger-fabric-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "install-chaincode-hyperledger-fabric-deployment-helm-chart"></a>
## Install Chaincode Hyperledger Fabric Deployment Helm Chart
---
A [Helm chart](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-chaincode-install) for chaincode installation on a peer.


<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the Helm chart, make sure to have the following prerequisites:

- Kubernetes cluster up and running.
- A HashiCorp Vault instance is set up and configured to use Kubernetes service account token-based authentication.
- The Vault is unsealed and initialized.
- Helm installed.


<a name = "chart-structure"></a>
## Chart Structure
---
The structure of the Helm chart is as follows:

```
fabric-chaincode-install/
  |- templates/
      |- _helpers.yaml
      |- install_chaincode.yaml
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `templates/`: Contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `install_chaincode.yaml`: The certificates-init retrieves certificates and credentials from Vault and stores them in a local directory. The installchaincode installs the chaincode on the peer. Both containers are used to prepare the peer for running chaincode.
- `Chart.yaml`: Contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: Provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-chaincode-install/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

### Metadata

| Name                   | Description                                                              | Default Value                                     |
| ----------------       | -------------------------------------------------------------------------| --------------------------------------------------|
| network.version        | HyperLedger Fabric network version                                       | 2.2.2                                             |
| namespace              | Namespace for organization's peer                                        | org1-net                                  |
| images.fabrictools     | Valid image name and version for Fabric tools                            | ghcr.io/hyperledger/bevel-fabric-tools:2.2.2                    |
| images.alpineutils     | Valid image name and version to read certificates from the Vault server  | ghcr.io/hyperledger/bevel-alpine:latest           |
| labels                 | Custom labels for the organization                                       | ""                                                |

### Peer

| Name        | Description                                      | Default Value               |
| ------------| -------------------------------------------------| ----------------------------|
| name        | Name of the peer as per deployment YAML          | peer0                       |
| address     | Address of the peer and its grpc cluster IP port | peer0.org1-net:7051 |
| localmspid  | Local MSPID for the organization                 | Org1MSP                     |
| loglevel    | Log level for the organization's peer            | info                        |
| tlsstatus   | TLS status for the organization's peer           | true                        |

### Vault

| Name                  | Description                                                       | Default Value                             |
| ----------------------| ------------------------------------------------------------------| ------------------------------------------|
| role                  | Vault role for the organization                                   | vault-role                                |
| address               | Vault server address                                              | ""                                        |
| authpath              | Kubernetes auth backend configured in Vault for the organization  | devorg1-net-auth             |
| adminsecretprefix     | Vault secretprefix for admin                                      | secretsv2/data/crypto/peerOrganizations/org1-net/users/admin                 |
| orderersecretprefix   | Vault secretprefix for orderer                                    | secretsv2/data/crypto/peerOrganizations/org1-net/orderer               |
| secretgitprivatekey   | Secret for Git private key                                        | secretsv2/data/credentials/org1-net/git   |
| serviceaccountname    | Service account name for Vault                                    | vault-auth                                |
| type                  | Provide the type of vault                                         | hashicorp    |
| imagesecretname       | Imagesecret name for Vault                                        | ""                                        |
| tls                   | Kubernetes secret for Vault ca.cert                               | ""                                        |

### Orderer

| Name      | Description               | Default Value                |
| ----------| --------------------------| -----------------------------|
| address   | Address for the orderer   | orderer1.org1proxy.blockchaincloudpoc.com:443 |

### Chaincode

| Name                        | Description                                                       | Default Value                                               |
| ----------------------------| ------------------------------------------------------------------| ------------------------------------------------------------|
| builder                     | Valid chaincode builder image for Fabric                          | hyperledger/fabric-ccenv:2.2.2                              |
| name                        | Name of the chaincode to be installed                             | example                                                          |
| version                     | Chaincode version to be installed                                 | 1                                                      |
| language                    | Language of the chaincode                                         | golang                                                      |
| maindirectory               | Path to the main.go package if different from chaincode directory | cmd                                                         |
| repository.hostname         | Chaincode remote Git repository hostname                          | github.com                                   |
| repository.URL              | Chaincode remote Git repository URL                               | github.com/hyperledger-bevel/bevel-samples.git    |
| repository.branch           | Chaincode remote Git repository branch to be cloned for chaincode | main                                                     |
| repository.path             | Git repository path containing chaincodes                         | "."                      |
| repository.git_username     | Username for the Git repository                                   | user                                                        |


<a name = "deployment"></a>
## Deployment
---

To deploy the fabric-chaincode-install Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-chaincode-install/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./fabric-chaincode-install
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the fabric-chaincode-install node to the Kubernetes cluster based on the provided configurations.


<a name = "verification"></a>
## Verification
---

To verify the deployment, we can use the following command:
```
$ kubectl get jobs -n <namespace>
```
Replace `<namespace>` with the actual namespace where the Job was created. This command will display information about the Job, including the number of completions and the current status of the Job's pods.


<a name = "updating-the-deployment"></a>
## Updating the Deployment
---

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-chaincode-install/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./fabric-chaincode-install
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the fabric-chaincode-install node is up to date.


<a name = "deletion"></a>
## Deletion
---

To delete the deployment and associated resources, run the following Helm command:
```
$ helm uninstall <release-name>
```
Replace `<release-name>` with the name of the release. This command will remove all the resources created by the Helm chart.


<a name = "contributing"></a>
## Contributing
---
If you encounter any bugs, have suggestions, or would like to contribute to the [Install Chaincode Hyperledger Fabric Deployment Helm Chart](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-chaincode-install), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger-bevel/bevel).


<a name = "license"></a>
## License

This chart is licensed under the Apache v2.0 license.

Copyright &copy; 2023 Accenture

### Attribution

This chart is adapted from the [charts](https://hyperledger.github.io/bevel/) which is licensed under the Apache v2.0 License which is reproduced here:

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
