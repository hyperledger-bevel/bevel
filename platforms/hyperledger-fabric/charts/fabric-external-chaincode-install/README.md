[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "install-external-chaincode-hyperledger-fabric-deployment"></a>
# Install External Chaincode Hyperledger Fabric Deployment

- [Install External Chaincode Hyperledger Fabric Deployment Helm Chart](#install-external-chaincode-hyperledger-fabric-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "install-external-chaincode-hyperledger-fabric-deployment-helm-chart"></a>
## Install External Chaincode Hyperledger Fabric Deployment Helm Chart
---
A [Helm chart](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-external-chaincode-install) for external chaincode installation.


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
fabric-external-chaincode-install/
  |- templates/
      |- _helpers.yaml
      |- install_external_chaincode.yaml
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `templates/`: Contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `install_external_chaincode.yaml`: The certificates-init retrieves TLS certificates and MSP certificates from Vault and stores them in a local directory. The package-init retrieves the chaincode package from Vault and stores it in a local directory. The "instextcc" installs the chaincode on the peer.
- `Chart.yaml`: Contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: Provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-external-chaincode-install/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

### Metadata

| Name                   | Description                                                              | Default Value                                     |
| -----------------------| -------------------------------------------------------------------------| --------------------------------------------------|
| network.version        | HyperLedger Fabric network version                                       | 2.2.2                                             |
| namespace              | Namespace for organization's peer                                        | org1-net                                  |
| images.fabrictools     | Valid image name and version for Fabric tools                            |ghcr.io/hyperledger/bevel-fabric-tools:2.2.2                    |
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

| Name                  | Description                                                       | Default Value                                       |
| ----------------------| ------------------------------------------------------------------| ----------------------------------------------------|
| role                  | Vault role for the organization                                   | vault-role                                          |
| address               | Vault server address                                              | ""                                                  |
| authpath              | Kubernetes auth backend configured in Vault for the organization  | devorg1-net-auth                        |
| chaincodesecretprefix | Vault secretprefix for chaincode                                  | secretsv2/data/crypto/peerOrganizations/org1-net/peers/peer0.org1-net/chaincodes                       |
| adminsecretprefix     | Vault secretprefix for admin                                      | secretsv2/data/crypto/peerOrganizations/org1-net/users/admin                        |
| orderersecretprefix   | Vault secretprefix for orderer                                    | secretsv2/data/crypto/peerOrganizations/org1-net/orderer                        |
| serviceaccountname    | Service account name for Vault                                    | vault-auth                                          |
| type                  | Provide the type of vault                                         | hashicorp    |
| imagesecretname       | Imagesecret name for Vault                                        | ""                                                  |
| secretgitprivatekey   | Secret for Git private key                                        | secretsv2/data/credentials/org1-net/git?git_password             |
| tls                   | Kubernetes secret for Vault ca.cert                               | ""                                                  |
| chaincodepackageprefix | Vault secretprefix with the package details saved in base64 format                         | secretsv2/data/crypto/peerOrganizations/org1-net/chaincodes/example/package/v1             |

### Chaincode

| Name             | Description                                      | Default Value     |
|------------------|--------------------------------------------------|-------------------|
| name             | Name of the chaincode to be installed            | example               |
| version          | Chaincode version to be installed                | 1               |
| tls_disabled     | tls is disabled or not                           | true              |
| address          | Chaincode server address                         | ""                |


<a name = "deployment"></a>
## Deployment
---

To deploy the fabric-external-chaincode-install Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-external-chaincode-install/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./fabric-external-chaincode-install
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the fabric-external-chaincode-install node to the Kubernetes cluster based on the provided configurations.


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

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-external-chaincode-install/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./fabric-external-chaincode-install
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the fabric-external-chaincode-install node is up to date.


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
If you encounter any bugs, have suggestions, or would like to contribute to the [Install External Chaincode Hyperledger Fabric Deployment Helm Chart](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-external-chaincode-install), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger-bevel/bevel).


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
