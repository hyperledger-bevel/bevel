[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "fabric-cacti-connector-hyperledger-fabric-deployment"></a>
# Fabric Connector Hyperledger Fabric Deployment

- [Fabric Connector Hyperledger Fabric Deployment Helm Chart](#fabric-cacti-connector-hyperledger-fabric-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "fabric-cacti-connector-hyperledger-fabric-deployment-helm-chart"></a>
## Fabric Connector Hyperledger Fabric Deployment Helm Chart
---
A [Helm chart](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric_connector) for Cactus Fabric Connector.


<a name = "prerequisites"></a>
## Prerequisites
---
Before deploying the Helm chart, make sure to have the following prerequisites:

- Kubernetes cluster up and running.
- A HashiCorp Vault instance is set up and configured to use Kubernetes service account token-based authentication.
- The Vault is unsealed and initialized.
- HAproxy is required as ingress controller.
- Helm installed.


<a name = "chart-structure"></a>
## Chart Structure
---
The structure of the Helm chart is as follows:

```
fabric_connector/
  |- templates/
      |- _helpers.yaml
      |- configmap.yaml
      |- deployment.yaml
      |- service.yaml
  |- .helmignore
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `templates/`: Contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `configmap.yaml`: Contains the configuration for the Hyperledger Cactus plugins. The plugins are used to interact with Hyperledger Fabric networks.
- `deployment.yaml`: The certificates-init retrieves TLS certificates from Vault and stores them in the filesystem. The cactus-connector runs the Hyperledger Cacti connector, which allows applications to interact with Fabric networks.
- `service.yaml`: Responsible for routing incoming traffic to Pods labeled "{{ .Release.Name }}-cactus-connector". For HAProxy, an Ingress resource is set up to manage traffic with SSL passthrough, ensuring end-to-end TLS encryption.
- `.helmignore.yaml`: 
- `Chart.yaml`: Contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: Provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/fabric_connector/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

### Metadata

| Name              | Description                                           | Default Value       |
| ------------------| ------------------------------------------------------| ------------------- |
| namespace         | Namespace where this deployment will be created       | manufacturer-net    |
| replicaCount      | Number of replicas                                    | 1                   |

### Image

| Name              | Description                           | Default Value                                       |
| ------------------| ------------------------------------- | ----------------------------------------------------|
| repository        | Docker image of the API server        | ghcr.io/hyperledger/cactus-cmd-api-server:1.1.3     |
| alpineutils       | Docker image of the alpine utils      | ghcr.io/hyperledger/bevel-alpine:latest             |
| pullPolicy        | Pull policy of the docker image       | IfNotPresent                                        |

### Service

| Name              | Description                           | Default Value       |
|-------------------|-------------------------------------- |-------------------- |
| type              | Service type for the Cactus API server| ClusterIP           |
| port              | Port for the above service            | 4000                |

### Plugins

| Name                      | Description                                   | Default Value                                                                         |
| --------------------------| ----------------------------------------------| ------------------------------------------------------------------------------------- |
| packageName               | Package name for the connector plugin         | "@hyperledger/cactus-plugin-ledger-connector-fabric"                                  |
| type                      | Type for the connector plugin                 | org.hyperledger.cactus.plugin_import_type.LOCAL                                       |
| action                    | Action for the connector plugin               | org.hyperledger.cactus.plugin_import_action.INSTALL                                   |
| instanceId                | Unique instance id for multiple connectors    | "12345678"                                                                            |
| dockerBinary              | Docker binary path                            | "usr/local/bin/docker"                                                                |
| caName                    | CA name for the Fabric network                | ca.manufacturer-net                                                                   |
| caAddress                 | CA address for the Fabric network             | ca.manufacturer-net:7054                                                              |
| corePeerMSPconfigpath     | MSP config path for the core peer             | "/opt/gopath/src/github.com/hyperledger/fabric/crypto/admin/msp"                      |
| corePeerAdmincertFile     | Admin cert file for the core peer             | "/opt/gopath/src/github.com/hyperledger/fabric/crypto/admin/msp/cacerts/ca.crt"       |
| corePeerTlsRootcertFile   | TLS root cert file for the core peer          | "/opt/gopath/src/github.com/hyperledger/fabric/crypto/admin/msp/tlscacerts/tlsca.crt" |
| ordererTlsRootcertFile    | TLS root cert file for the orderer            | "/opt/gopath/src/github.com/hyperledger/fabric/crypto/orderer/tls/ca.crt"             |
| discoveryEnabled          | Enable/disable discovery service              | "true"                                                                                |
| asLocalhost               | Enable/disable localhost for connections      | "true"                                                                                |

### Env 

| Name                       | Description                                      | Default Value  |
| ---------------------------| -------------------------------------------------| ---------------|
| authorizationProtocol      | Authorization protocol for Cactus connector      | "NONE"         |
| authorizationConfigJson    | Authorization config JSON for Cactus connector   | "{}"           |
| grpcTlsEnabled             | Enable/disable gRPC TLS for Cactus connector     | "false"        |

### Proxy

| Name              | Description                                       | Default Value                                         |
| ------------------| --------------------------------------------------|-------------------------------------------------------|
| provider          | Proxy provider (Only haproxy supported)           | "haproxy"                                             |
| external_url      | Complete external URL for Connector service       | manufacturer-net.hf.demo.aws.blockchaincloudpoc.com   |

### Vault

| Name                | Description                                     | Default Value                                                         |
| --------------------| ------------------------------------------------|---------------------------------------------------------------------- |
| role                | Vault role for the organization                 | vault-role                                                            |
| address             | Vault server address                            | http://vault.internal.demo.aws.blockchaincloudpoc.com:9001            |
| authpath            | Kubernetes auth backend configured in Vault     | demo-fabricmanufacturer-net-auth                                      |
| adminsecretprefix   | Vault secret prefix for admin user              | secretsv2/data/crypto/peerOrganizations/manufacturer-net/users/admin  |
| orderersecretprefix | Vault secret prefix for orderer                 | secretsv2/data/crypto/peerOrganizations/manufacturer-net/orderer      |
| serviceaccountname  | Service account name for Vault                  | vault-auth                                                            |
| tls                 | Enable/disable TLS for Vault communication      | false                                                                 |

### Peer

| Name              | Description                                   | Default Value               |
| ------------------| ----------------------------------------------| ----------------------------|
| name              | Name of the peer as per deployment yaml       | peer0                       |
| peerID            | Peer ID for the organization's peer           | peer0.manufacturer-net      |
| localmspid        | Local MSP ID for the organization             | manufacturerMSP             |
| tlsstatus         | Enable/disable TLS for organization's peer    | true                        |
| address           | Address for the peer                          | peer0.manufacturer-net:7051 |

### Orderer

| Name         | Description                 | Default Value                    |
| -------------| ----------------------------| ---------------------------------|
| address      | Address for the orderer     | orderer1.supplychain-net:7050    |


<a name = "deployment"></a>
## Deployment
---

To deploy the fabric_connector Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric_connector/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./fabric_connector
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the fabric_connector node to the Kubernetes cluster based on the provided configurations.


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

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric_connector/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./fabric_connector
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the fabric_connector node is up to date.


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
If you encounter any bugs, have suggestions, or would like to contribute to the [Fabric Connector Hyperledger Fabric Deployment Helm Chart](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric_connector), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger-bevel/bevel).


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
