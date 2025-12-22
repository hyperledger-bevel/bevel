[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "operation-console-hyperledger-fabric-deployment"></a>
# Operation Console Hyperledger Fabric Deployment

- [Operation Console Hyperledger Fabric Deployment Helm Chart](#operation-console-hyperledger-fabric-deployment-helm-chart)
- [Prerequisites](#prerequisites)
- [Chart Structure](#chart-structure)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Verification](#verification)
- [Updating the Deployment](#updating-the-deployment)
- [Deletion](#deletion)
- [Contributing](#contributing)
- [License](#license)


<a name = "operation-console-hyperledger-fabric-deployment-helm-chart"></a>
## Operation Console Hyperledger Fabric Deployment Helm Chart
---
A [Helm chart](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/operation_console) for Fabric Operations Console.


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
operation_console/
  |- templates/
      |- _helpers.yaml
      |- configmap.yaml
      |- deployment.yaml
      |- pvc.yaml
      |- service.yaml
  |- Chart.yaml
  |- README.md
  |- values.yaml
```

- `templates/`: Contains the Kubernetes manifest templates that define the resources to be deployed.
- `helpers.tpl`: Contains custom label definitions used in other templates.
- `configmap.yaml`: Store configuration for the fabric-console
- `deployment.yaml`: Defines a StatefulSet with one replica that manages three containers: couchdb, fabric-console, and configtxlator. The couchdb container will be used to store the data for the Fabric network and it will be exposed on port 5984. The fabric-console container will be used to interact with the Fabric network and it will be exposed on port 3000. The configtxlator container will be used to generate and manage configuration transactions for the Fabric network and it will be exposed on port 7059.
- `pvc.yaml`: Defines a persistent volume claim that will be used to store the data for the CouchDB database.
- `service.yaml`: configures a Kubernetes Service and an Ingress. The service has three ports: console (port 3000) is exposed for the fabric-console, couchdb (port 5984) is exposed for the couchdb database, and configtxlator (port 7059) is exposed for the configtxlator container. The service can be exposed in two ways: ClusterIP and NodePort. Optionally, if haproxy is selected, ingress will route traffic to the Service using the host and path.
- `Chart.yaml`: Contains the metadata for the Helm chart, such as the name, version, and description.
- `README.md`: Provides information and instructions about the Helm chart.
- `values.yaml`: Contains the default configuration values for the Helm chart.


<a name = "configuration"></a>
## Configuration
---
The [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/develop/platforms/hyperledger-fabric/charts/operation_console/values.yaml) file contains configurable values for the Helm chart. We can modify these values according to the deployment requirements. Here are some important configuration options:

### Metadata

| Name                  | Description                                                           | Default Value                                         |
| ----------------------| --------------------------------------------------------------------- | ------------------------------------------------------|
| namespace             | Provide the namespace for organization's peer                         | org1-net                                      |
| images.couchdb        | Valid image name and version for fabric couchdb                       | couchdb:3.1.1                                         |
| images.console        | Valid image name and version for fabric operations console            | ghcr.io/hyperledger-labs/fabric-console:latest        |
| images.configtxlator  | Valid image name and version to read certificates from vault server   | ghcr.io/hyperledger/bevel-fabric-tools:2.2.2                        |
| labels                | Custom labels (other than predefined ones)                            | ""                                                    |


### Storage

| Name          | Description                     | Default Value       
| --------------| --------------------------------| ------------------- |
| couchdb       | Storage class name for couchdb  | gp2                 |
| storagesize   | Storage size for couchdb        | 512Mi               |

### Service

| Name                          | Description                                     | Default Value       |
| ------------------------------| ------------------------------------------------| ------------------- |
| name                          | Name of the service as per deployment yaml      | fabconsole          |
| serviceaccountname            | Service account name for vault                  | default             |
| imagesecretname               | Image secret name for vault                     | ""                  |
| servicetype                   | Service type for the peer                       | ClusterIP           |
| default_consortium            | Default consortium value                        | SampleConsortium    |
| loadBalancerType              | Load balancer type for the service              | ""                  |
| ports.console.nodeport        | NodePort for grpc service (optional)            | ""                  |
| ports.console.clusteripport   | Cluster IP port for grpc service                | 3000                |
| ports.couchdb.nodeport        | NodePort for couchdb service (optional)         | ""                  |
| ports.couchdb.clusteripport   | Cluster IP port for couchdb service             | 5984                |



### Annotations

| Name          | Description                                   | Default Value       |
| --------------| ----------------------------------------------| ------------------- |
| service       | Extra annotations for service                 | ""                  |
| pvc           | Extra annotations for PersistentVolumeClaim   | ""                  |
| deployment    | Extra annotations for deployment              | ""                  |



### Proxy

| Name                      | Description                                       | Default Value                         |
| --------------------------| --------------------------------------------------| --------------------------------------|
| proxy.provider            | Proxy/ingress provider (none or haproxy)          | haproxy                               |
| proxy.external_url_suffix | External URL suffix of the organization           | orderer1.org1proxy.blockchaincloudpoc.com:443           |


<a name = "deployment"></a>
## Deployment
---

To deploy the operation_console Helm chart, follow these steps:

1. Modify the [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/operation_console/values.yaml) file to set the desired configuration values.
2. Run the following Helm command to install the chart:
    ```
    $ helm repo add bevel https://hyperledger.github.io/bevel/
    $ helm install <release-name> ./operation_console
    ```
Replace `<release-name>` with the desired name for the release.

This will deploy the operation_console node to the Kubernetes cluster based on the provided configurations.


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

If we need to update the deployment with new configurations or changes, modify the same [values.yaml](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/operation_console/values.yaml) file with the desired changes and run the following Helm command:
```
$ helm upgrade <release-name> ./operation_console
```
Replace `<release-name>` with the name of the release. This command will apply the changes to the deployment, ensuring the operation_console node is up to date.


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
If you encounter any bugs, have suggestions, or would like to contribute to the [Operation Console Hyperledger Fabric Deployment Helm Chart](https://github.com/hyperledger-bevel/bevel/blob/main/platforms/hyperledger-fabric/charts/operation_console), please feel free to open an issue or submit a pull request on the [project's GitHub repository](https://github.com/hyperledger-bevel/bevel).


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
