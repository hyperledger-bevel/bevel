[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "external-chaincode-hyperledger-fabric-deployment"></a>
# External Chaincode Hyperledger Fabric Deployment

- [External Chaincode Tools Hyperledger Fabric Deployment Helm Chart](#external-chaincode-hyperledger-fabric-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "external-chaincode-hyperledger-fabric-deployment-helm-chart"></a>
## External Chaincode Hyperledger Fabric Deployment Helm Chart
---
A [Helm chart](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-external-chaincode) for external chaincode server deployment.


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
fabric-external-chaincode/
  |- templates/
      |- _helpers.yaml
      |- deployment.yaml
      |- service.yaml
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `templates/`: Contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `deployment.yaml`: The certificates-init gets the chaincode certificates from Vault and mounts them into the Pod. The chaincode runs the chaincode and exposes port 9999.
- `service.yaml`: Exposing the chaincode to the network. The service creates a clusterIP that can be used to access the chaincode from other Pods in the cluster.
- `Chart.yaml`: Contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: Provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric-external-chaincode/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

### Metadata

| Name                      | Description                                           | Default Value                                     |
| --------------------------| ------------------------------------------------------| --------------------------------------------------|
| namespace                 | Provide the namespace for organization's peer         | org1-net                                          |
| network.version           | Version of the network                                | 2.2.2                                             |
| images.external_chaincode | Valid image name and version for chaincode server     | ghcr.io/hyperledger/bevel-samples-example:1.0     |
| images.alpineutils        | Valid image name and version for Alpine utilities     | ghcr.io/hyperledger/bevel-alpine:latest           |
| labels                    | Custom labels                                         | ""                                                |


### Chaincode

| Name              | Description                                                                   | Default Value    |
| ------------------| ------------------------------------------------------------------------------| -----------------|
| org               | Organisation name                                                             | manufacturer     |
| name              | Chaincode name                                                                | example          |
| version           | Chaincode version eg. 1                                                       | 1                |
| ccid              | Chaincode ID generated after chaincode is installed                           | ""               |
| crypto_mount_path | Path in the chaincode server container where the crypto needs to be mounted   | ""               |
| tls               | If TLS is disabled or not                                                     | false            |


### Vault

| Name                  | Description                                                                   | Default Value                 |
| ----------------------| ------------------------------------------------------------------------------|-------------------------------|
| role                  | Provide the vaultrole for an organization                                     | vault-role                    |
| address               | Provide the vault server address                                              | ""                            |
| authpath              | Provide the kubernetes auth backend configured in vault for an organization   | devorg1-net-auth                            |
| chaincodesecretprefix | Provide the value for vault secretprefix                                      | secretsv2/data/crypto/peerOrganizations/org1-net/chaincodes/example/certificate/v1 |
| serviceaccountname    | Provide the serviceaccountname for vault                                      | vault-auth                    |
| type                  | Provide the type of vault                                                     | hashicorp    |
| imagesecretname       | Provide the imagesecretname for vault                                         | ""                            |
| tls                   | Kubernetes secret for vault ca.cert                                           | ""                            |


### Service

| Name                      | Description                                                       | Default Value   |
| --------------------------|-------------------------------------------------------------------|-----------------|
| servicetype               | Provide the servicetype for a peer                                | ClusterIP       |
| loadBalancerType          | Load balancer type                                                | ""              |
| ports.grpc.nodeport       | Nodeport for grpc service in the range of 30000-32767 (optional)  | ""              |
| ports.grpc.clusteripport  | Cluster IP port for grpc service to be exposed                    | 7052            |


<a name = "deployment"></a>
## Deployment
---

To deploy the fabric-external-chaincode Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-external-chaincode/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./fabric-external-chaincode
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the fabric-external-chaincode node to the Kubernetes cluster based on the provided configurations.


<a name = "verification"></a>
## Verification
---

To verify the deployment, we can use the following command:
```
$ kubectl get deployments -n <namespace>
```
Replace `<namespace>` with the actual namespace where the deployment was created. The command will display information about the deployment, including the number of replicas and their current status.


<a name = "updating-the-deployment"></a>
## Updating the Deployment
---

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-external-chaincode/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./fabric-external-chaincode
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the fabric-external-chaincode node is up to date.


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
If you encounter any bugs, have suggestions, or would like to contribute to the [External Chaincode Hyperledger Fabric Deployment Helm Chart](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-external-chaincode), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger-bevel/bevel).


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
