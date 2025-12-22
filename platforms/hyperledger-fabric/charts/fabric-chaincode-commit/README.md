[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "commit-chaincode-hyperledger-fabric-deployment"></a>
# Commit Chaincode Hyperledger Fabric Deployment

- [Commit Chaincode Hyperledger Fabric Deployment Helm Chart](#commit-chaincode-hyperledger-fabric-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "commit-chaincode-hyperledger-fabric-deployment-helm-chart"></a>
## Commit Chaincode Hyperledger Fabric Deployment Helm Chart
---
A [Helm chart](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-chaincode-commit) commits a chaincode to a channel.


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
fabric-chaincode-commit/
  |- templates/
      |- _helpers.yaml
      |- commit_chaincode.yaml
      |- configmap.yaml
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `templates/`: Contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `commit_chaincode.yaml`: The certificates-init fetches certificates from Vault and stores them in local directories, formats the CA certificates for each Endorsing organization, and writes the CA certificates back to Vault. The commitchaincode commits a chaincode to a channel, first checking if it has already been committed, then checking if it is ready to be committed, and finally checking if a private data collection or endorsement policy is used.
- `configmap.yaml`: Includes the collection configuration file. The commitchaincode container uses this data to commit the chaincode to the channel.
- `Chart.yaml`: Contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: Provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-chaincode-commit/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

### Metadata

| Name                  | Description                                       | Default Value                                     |
| ----------------------| --------------------------------------------------| --------------------------------------------------|
| namespace             | Namespace for organization's peer                 | org1-net                                        |
| images.fabrictools    | Image name and version for fabric tools           |ghcr.io/hyperledger/bevel-fabric-tools:2.2.2                    |
| images.alpineutils    | Image name and version to read certificates       | ghcr.io/hyperledger/bevel-alpine:latest           |
| labels                | Custom labels (if applicable)                     | ""                                                |

### Peer

| Name             | Description                           | Default Value                  |
| -----------------| --------------------------------------| -------------------------------|
| name             | Name of the peer                      | peer0                          |
| address          | Address of the peer                   | peer0.org1-net:7051           |
| localmspid       | Local MSP ID for organization         | Org1MSP                        |
| loglevel         | Log level for organization's peer     | info                           |
| tlsstatus        | TLS status for organization's peer    | true                           |

### Vault

| Name                  | Description                                    | Default Value                    |
| ----------------------| -----------------------------------------------| -------------------------------- |
| role                  | Vault role for the organization                | vault-role                       |
| address               | Vault server address                           | ""                               |
| authpath              | Kubernetes auth backend configured in Vault    | devorg1-net-auth         |
| adminsecretprefix     | Vault secret prefix for admin credentials      | secretsv2/data/crypto/peerOrganizations/org1-net/users/admin        |
| orderersecretprefix   | Vault secret prefix for orderer credentials    | secretsv2/data/crypto/peerOrganizations/org1-net/orderer      |
| secretpath            | Vault secret path                              | secretsv2                        |
| serviceaccountname    | Service account name for Vault                 | vault-auth                       |
| type                  | Provide the type of vault                      | hashicorp                        |
| imagesecretname       | Image secret name for Vault                    | ""                               |
| tls                   | TLS configuration for Vault communication      | ""                               |

### Orderer

| Name          | Description                          | Default Value   |
| --------------| -------------------------------------| ----------------|
| address       | Address for orderer including port   | orderer1.org1proxy.blockchaincloudpoc.com:443             |

### Chaincode

| Name                          | Description                                               | Default Value                             |
| ------------------------------| ----------------------------------------------------------| ------------------------------------------|
| builder                       | Chaincode builder image for Fabric                        | hyperledger/fabric-ccenv:2.2.2            |
| name                          | Name of the chaincode to be committed                     | example                                   |
| version                       | Version of the chaincode to be committed                  | 1                                         |
| sequence                      | Sequence of the chaincode (for Fabric 2.2.x)              | 1                                         |
| lang                          | Language of the chaincode                                 | golang                                    |
| commitarguments               | Commit arguments for the chaincode                        | ""                                        |
| endorsementpolicies           | Endorsement policies for the chaincode                    | ""                                        |
| repository.hostname           | Git repository hostname                                   | github.com                                |
| repository.git_username       | Git repository username                                   | user                                      |
| repository.url                | Git repository URL                                        | github.com/hyperledger-bevel/bevel-samples.git  |
| repository.branch             | Git repository branch                                     | main                                      |
| repository.path               | Path to the chaincode in the repository                   | .                                         |
| repository.collectionsconfig  | Collections configuration for the chaincode               | ""                                        |
| pdc.enabled                   | Enable private data collections for the chaincode         | false                                     |
| pdc.collectionsconfig         | Collections configuration for private data collections    | ""                                        |

### Channel

| Name       | Description           | Default Value   |
| -----------|-----------------------| ----------------|
| name       | Name of the channel   | mychannel       |

### Endorsers

| Name              | Description                                                   | Default Value    |
| ------------------| --------------------------------------------------------------| -----------------|
| creator           | Namespace of the creator organization                         | creator_org      |
| name              | Names of organizations approving the chaincode                | ""               |
| corepeeraddress   | Core peer addresses of organizations approving the chaincode  | ""               |
| nameslist         | List of organization names approving the chaincode            | {}               |


<a name = "deployment"></a>
## Deployment
---

To deploy the fabric-chaincode-commit Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-chaincode-commit/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./fabric-chaincode-commit
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the fabric-chaincode-commit node to the Kubernetes cluster based on the provided configurations.


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

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-chaincode-commit/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./fabric-chaincode-commit
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the fabric-chaincode-commit node is up to date.


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
If you encounter any bugs, have suggestions, or would like to contribute to the [Commit Chaincode Hyperledger Fabric Deployment Helm Chart](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-chaincode-commit), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger-bevel/bevel).


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
