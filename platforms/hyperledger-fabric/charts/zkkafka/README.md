[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "zookeeper-and-kafka-chaincode-hyperledger-fabric-deployment"></a>
# Zookeeper and Kafka Hyperledger Fabric Deployment

- [Zookeeper and Kafka Hyperledger Fabric Deployment Helm Chart](#zookeeper-and-kafka-hyperledger-fabric-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "zookeeper-and-kafka-hyperledger-fabric-deployment-helm-chart"></a>
## Zookeeper and Kafka Hyperledger Fabric Deployment Helm Chart
---
A [Helm chart](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/zkkafka) to deploy zookeeper & kafka.


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
zkkafka/
  |- templates/
      |- _helpers.yaml
      |- deployment.yaml
      |- service.yaml
      |- volume.yaml
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `templates/`: Contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `deployment.yaml`: Deploy a Zookeeper and Kafka in a Kubernetes cluster and also defines an initContainer that is used to check the health of the Zookeeper pod before the Kafka pods are started.
- `service.yaml`: Defines two services, one for ZooKeeper and another for Kafka. These services expose specific ports and are responsible for routing traffic to the corresponding pods based on their label selectors with in cluster only. 
- `volume.yaml`: Creates the persistent volumes that are used by each Kafka pods.
- `Chart.yaml`: Contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: Provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/zkkafka/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

### Metadata

| Name                  | Description                                                    | Default Value                         |
| ----------------------| ---------------------------------------------------------------| --------------------------------------|
| namespace             | Provide the namespace for organization's Zookeeper and Kafka   | org1-net                           |
| images.kafka          | Valid image name and version for Fabric Kafka                  | ghcr.io/hyperledger/bevel-fabric-kafka:0.4.18       |
| images.zookeeper      | Valid image name and version for Fabric Zookeeper              | ghcr.io/hyperledger/bevel-fabric-kafka:0.4.18   |
| images.healthcheck    | Valid image name and version for Zookeeper health check        | busybox                               |
| labels                | Custom labels for the deployment                               | ""                                    |

### Deployment

| Name          | Description                      | Default Value |
| ------------- | ---------------------------------| --------------|
| annotations   | Annotations for the deployment   | ""            |

### Storage

| Name              | Description                     | Default Value  |
| ------------------| --------------------------------| ---------------|
| storagesize       | Storagesize for storage class   | 512Mi          |
| storageclassname  | Storageclassname for orderer    | aws-storageclass    |

### Kafka

| Name                  | Description                               | Default Value  |
| ----------------------| ------------------------------------------| ---------------|
| name                  | Name for Kafka deployment                 | kafka          |
| brokerservicename     | Brokerservicename for Kafka and orderer   | broker         |
| replicas              | Number of replicas for Kafka              | 4              |

### Zookeeper

| Name                      | Description                                                           | Default Value |
| --------------------------| ----------------------------------------------------------------------|---------------|
| name                      | Name for Zookeeper deployment                                         | zookeeper     |
| peerservicename           | Peerservicename for Zookeeper peers and leader election               | zoo           |
| replicas                  | Number of replicas for Zookeeper                                      | 4             |
| readinessthreshold        | Threshold to check if all specified Zookeeper are up and running      | 4             |
| readinesscheckinterval    | Interval in seconds to check readiness of Zookeeper services          | 5             |


<a name = "deployment"></a>
## Deployment
---

To deploy the zkkafka Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/zkkafka/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./zkkafka
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the zkkafka node to the Kubernetes cluster based on the provided configurations.


<a name = "verification"></a>
## Verification
---

To verify the deployment, we can use the following command:
```
$ kubectl get statefulsets -n <namespace>
```
Replace `<namespace>` with the actual namespace where the StatefulSet was created. This command will display information about the StatefulSet, including the number of replicas and their current status.


<a name = "updating-the-deployment"></a>
## Updating the Deployment
---

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/zkkafka/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./zkkafka
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the zkkafka node is up to date.


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
If you encounter any bugs, have suggestions, or would like to contribute to the [Zookeeper and Kafka Hyperledger Fabric Deployment Helm Chart](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/zkkafka), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger-bevel/bevel).


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
