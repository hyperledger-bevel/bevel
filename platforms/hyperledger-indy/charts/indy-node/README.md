[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# indy-node

This chart is a component of Hyperledger Bevel. The indy-node chart deploys a Hyperledger Indy node as a steward. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for more details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install university-steward-1 bevel/indy-node
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

> **Important**: Ensure the `indy-key-mgmt` and `indy-genesis` charts has been installed correctly before installing this.

## Installing the Chart

To install the chart with the release name `university-steward-1`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install university-steward-1 bevel/indy-node
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `university-steward-1` deployment:

```bash
helm uninstall university-steward-1
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters
### Global parameters
These parameters are referred to as same in each parent or child chart
| Name   | Description  | Default Value |
|--------|---------|-------------|
|`global.serviceAccountName` | The serviceaccount name that will be created for Vault Auth management| `vault-auth` |
| `global.cluster.provider` | Kubernetes cluster provider like AWS EKS or minikube. Currently ony `aws` and `minikube` is tested | `aws` |
| `global.cluster.cloudNativeServices` | only `false` is implemented, `true` to use Cloud Native Services (SecretsManager and IAM for AWS; KeyVault & Managed Identities for Azure) is for future  | `false`  |
| `global.proxy.provider` | The proxy or Ingress provider. Can be `none` or `ambassador` | `ambassador` |

### Storage

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `storage.keys` | Size of the PVC needed storing the formatted keys  | `512Mi` |
| `storage.data` | Size of the PVC needed storing the node data  | `4Gi` |
| `storage.reclaimPolicy` | Reclaim policy for the PVC. Choose from: `Delete` or `Retain` | `Delete` |
| `storage.volumeBindingMode` | Volume binding mode for the PVC. Choose from: `Immediate` or `WaitForFirstConsumer` | `Immediate` |
| `storage.allowedTopologies.enabled` | Check [bevel-storageclass](../../../shared/charts/bevel-storageclass/README.md) for details  | `false`  |

### Image
| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials  | `""`            |
| `image.initContainer`   | Init-container image repository and tag  | `ghcr.io/hyperledger/bevel-alpine-ext:latest`|
| `image.cli`   | Indy-cli indy-ledger-txn image repository and tag | `ghcr.io/hyperledger/bevel-indy-ledger-txn:latest`|
| `image.indyNode.repository`  | Indy Node image repository  | `ghcr.io/hyperledger/bevel-indy-node` |
| `image.indyNode.tag`  | Indy Node image tag/version  | `1.12.6` |

### Settings

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `settings.network` | Network Name for Indy  | `bevel` |
| `settings.addOrg` | Flag to denote if this is a new Node for existing Indy network  | `false` |
| `settings.serviceType` | Choose between `ClusterIP` or `NodePort`; `NodePort` must be used for no-proxy  | `ClusterIP` |
| `settings.node.ip` | Internal IP of the Indy node service  | `0.0.0.0` |
| `settings.node.publicIp` | External IP of the Indy node service, use same IP from genesis  | `""` |
| `settings.node.port` | Internal Port of the Indy node service  | `9711` |
| `settings.node.externalPort` | External IP of the Indy node service, use same port from genesis  | `15011` |
| `settings.client.ip` | Internal IP of the Indy client service  | `0.0.0.0` |
| `settings.client.publicIp` | External IP of the Indy client service, use same IP from genesis  | `""` |
| `settings.client.port` | Internal Port of the Indy client service  | `9712` |
| `settings.client.externalPort` | External IP of the Indy client service, use same port from genesis  | `15012` |

## License

This chart is licensed under the Apache v2.0 license.

Copyright &copy; 2024 Accenture

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
