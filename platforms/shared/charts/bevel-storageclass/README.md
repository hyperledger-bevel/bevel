[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)
# bevel-storageclass

This chart is a component of Hyperledger Bevel. The bevel-storageclass chart creates a kubernetes Storageclass that can be used to provision persistent volumes. The StorageClass supports encryption and can be configured to be used for different cloud providers. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install my-storageclass bevel/bevel-storageclass
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-storageclass`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install my-storageclass bevel/bevel-vault-mgmt
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-storageclass` deployment:

```bash
helm uninstall my-storageclass
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

These parameters are referred to as same in each parent or child chart
| Name   | Description  | Default Value |
|--------|---------|-------------|
| `global.cluster.provider` | Kubernetes cluster provider. choose from: minikube, aws, azure, gcp | `aws`  |

### Common parameters

| Name | Description    | Default Value     |
| -------------| ---------------------| -------------     |
| `provisioner`  | Optional field. Fill it only if you want to use a specific provisioner of your choice.<br>Otherwise, leave it empty to use the default provisioner based on the value of `global.cluster.provider`field.  | `""`   |
| `parameters.aws`       | Parameters for AWS storage provisioner in k-v format.  | `encrypted: "true"`  |
| `parameters.gcp`       | Parameters for GCP storage provisioner in k-v format.        | `type: pd-standard`<br>`fstype: ext4`<br>`replicationtype: none` |
| `parameters.minikube`  | Parameters for Minikube storage provisioner.   | `encrypted: "true"`   |
| `parameters.azure`  | Parameters for Azure storage provisioner.   | `skuName: StandardSSD_LRS`<br>`kind: Managed`   |
| `reclaimPolicy`   | The reclaim policy for persistent volumes created by the StorageClass. Supported values are: `Delete` or `Retain`. | `Delete`        |
| `volumeBindingMode`| The volume binding mode for persistent volumes created by the StorageClass. Supported values are: `Immediate` or `WaitForFirstConsumer`.| `Immediate`  |
| `allowedTopologies.enabled` | Set to `true` to provision for additional features for the storageclass| `true` |
| `allowedTopologies.matchLabelExpressions` | Array of k-v values for `allowedTopologies`   | `- key: failure-domain.beta.kubernetes.io/zone`<br>`values:`<br>`- "eu-west-1a"` |


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
