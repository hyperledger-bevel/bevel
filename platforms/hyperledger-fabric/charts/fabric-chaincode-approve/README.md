[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "approve-chaincode-hyperledger-fabric-deployment"></a>
# Approve Chaincode Hyperledger Fabric Deployment

- [Approve Chaincode Hyperledger Fabric Deployment Helm Chart](#approve-chaincode-hyperledger-fabric-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "approve-chaincode-hyperledger-fabric-deployment-helm-chart"></a>
## Approve Chaincode Hyperledger Fabric Deployment Helm Chart
---
A [Helm chart](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-chaincode-approve) to approve the chaincode.

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
fabric-chaincode-approve/
  |- templates/
      |- _helpers.yaml
      |- approve_chaincode.yaml
      |- configmap.yaml
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `templates/`: Contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `approve_chaincode.yaml`: Retrieves necessary certificates from Vault, checks if the chaincode is already approved. If it is, the job exits. If the chaincode is not approved, the job extracts the package ID of the chaincode and creates a command to approve the chaincode for the organization. The job then evaluates the endorsement policy, if any, and adds it to the command. Finally, the job runs the command to approve the chaincode.
- `configmap.yaml`: stores the private data collection configuration for a chaincode. The ConfigMap is optional, and it is only used if the chaincode.pdc.enabled value is set. Otherwise, the default configuration for the Fabric CA server will be used.
- `Chart.yaml`: Contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: Provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-chaincode-approve/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

## Parameters
---

### Metadata

| Name                  | Description                                                                       | Default Value                                    |
| ----------------------| ----------------------------------------------------------------------------------| -------------------------------------------------|
| namespace             | Provide the namespace for organization's peer                                     | org1-net                                 |
| images.fabrictools    | Provide the valid image name and version                                          | ghcr.io/hyperledger/bevel-fabric-tools:2.2.2                  |
| images.alpineutils    | Provide the valid image name and version to read certificates from vault server   | ghcr.io/hyperledger/bevel-alpine:latest          |
| labels                | Provide the custom labels                                                         | ""                                               |

### Peer

| Name          | Description                                                                                             | Default Value                |
| --------------| --------------------------------------------------------------------------------------------------------| -----------------------------|
| name          | Provide the name of the peer as per deployment yaml                                                     | peer0                        |
| address       | Provide the address of the peer which will update the channel about the anchor peer of the organization | peer0.org1-net:7051  |
| localmspid    | Provide the localmspid for organization                                                                 | Org1MSP                      |
| loglevel      | Provide the loglevel for organization's peer                                                            | debug                        |
| tlsstatus     | Provide the value for tlsstatus to be true or false for organization's peer                             | true                         |

### Vault

| Name                 | Description                                                                 | Default Value                |
| ---------------------| --------------------------------------------------------------------------  | -----------------------------|
| role                 | Provide the vaultrole for an organization                                   | vault-role                   |
| address              | Provide the vault server address                                            | ""                           |
| authpath             | Provide the kubernetes auth backed configured in vault for an organization  | devorg1-net-auth |
| adminsecretprefix    | Provide the value for vault secretprefix                                    | secretsv2/data/crypto/peerOrganizations/org1-net/users/admin    |
| orderersecretprefix  | Provide the value for vault secretprefix                                    | secretsv2/data/crypto/peerOrganizations/org1-nets/orderer  |
| serviceaccountname   | Provide the serviceaccount name for vault                                   | vault-auth                   |
| type                 | Provide the type of vault                                                   | hashicorp    |
| imagesecretname      | Provide the imagesecretname for vault                                       | ""                           |
| tls                  | Enable or disable TLS for vault communication                               | ""                           |

### Orderer

| Name         | Description                        | Default Value                 |
| -------------| -----------------------------------| ------------------------------|
| address      | Provide the address for orderer    | orderer1.org1proxy.blockchaincloudpoc.com:443  |

### Chaincode

| Name                          | Description                                               | Default Value                             |
| ------------------------------| ----------------------------------------------------------| ------------------------------------------|
| builder                       | Chaincode builder image for Fabric                        | hyperledger/fabric-ccenv:2.2.2            |
| name                          | Name of the chaincode to be committed                     | example                                   |
| version                       | Version of the chaincode to be committed                  | 1                                         |
| sequence                      | Chaincode sequence (applies to Fabric 2.2.x)              | 1                                         |
| lang                          | Language of the chaincode                                 | golang                                    |
| commitarguments               | Commit arguments for the chaincode                        | ""                                        |
| endorsementpolicies           | Endorsement policies for the chaincode                    | ""                                        |
| repository.hostname           | Hostname of the chaincode repository                      | github.com                                |
| repository.git_username       | Git username for the chaincode repository                 | user                                      |
| repository.url                | URL of the chaincode repository                           | github.com/hyperledger-bevel/bevel-samples.git  |
| repository.branch             | Branch of the chaincode repository                        | main                                      |
| repository.path               | Path to the chaincode within the repository               | .                                         |
| repository.collectionsconfig  | Collections configuration for the chaincode               | ""                                        |
| pdc.enabled                   | Enable private data collections for the chaincode         | false                                     |
| pdc.collectionsconfig         | Collections configuration for private data collections    | ""                                        |

### Channel

| Name    | Description            | Default Value |
| --------| -----------------------| ------------- |
| name    | Name of the channel    | mychannel     |


<a name = "deployment"></a>
## Deployment
---

To deploy the fabric-chaincode-approve Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-chaincode-approve/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./fabric-chaincode-approve
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the fabric-chaincode-approve job to the Kubernetes cluster based on the provided configurations.


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

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-chaincode-approve/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./fabric-chaincode-approve
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the fabric-chaincode-approve node is up to date.


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
If you encounter any bugs, have suggestions, or would like to contribute to the [Approve Chaincode Hyperledger Fabric Deployment Helm Chart](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-chaincode-approve), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger-bevel/bevel).

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
