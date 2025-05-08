[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# besu-node

This chart is a component of Hyperledger Bevel. The besu-node chart deploys a Hyperledger Besu node with different settings like validator or member. If enabled, the keys are then stored on the configured vault and stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install validator-1 bevel/besu-node
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

> **Important**: Ensure the `besu-genesis` chart has been installed before installing this. Also check the dependent charts.

## Installing the Chart

To install the chart with the release name `validator-1`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install validator-1 bevel/besu-node
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `validator-1` deployment:

```bash
helm uninstall validator-1
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
| `global.vault.type`  | Type of Vault to support other providers. Currently, only `hashicorp` is supported. | `hashicorp`    |
| `global.vault.role`  | Role used for authentication with Vault | `vault-role`    |
| `global.vault.address`| URL of the Vault server.    | `""`            |
| `global.vault.authPath`    | Authentication path for Vault  | `supplychain`            |
| `global.vault.secretEngine` | The value for vault secret engine name   | `secretsv2`  |
| `global.vault.secretPrefix` | The value for vault secret prefix which must start with `data/`   | `data/supplychain`  |
| `global.proxy.provider` | The proxy or Ingress provider. Can be `none` or `ambassador` | `ambassador` |
| `global.proxy.externalUrlSuffix` | The External URL suffix at which the Besu P2P and RPC service will be available | `test.blockchaincloudpoc.com` |
| `global.proxy.p2p` | The external port at which the Besu P2P service will be available. This port must be unique for a single cluster and enabled on Ambassador. | `15010` |

### Storage

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `storage.size` | Size of the PVC needed for Besu node  | `2Gi` |
| `storage.reclaimPolicy` | Reclaim policy for the PVC. Choose from: `Delete` or `Retain` | `Delete` |
| `storage.volumeBindingMode` | Volume binding mode for the PVC. Choose from: `Immediate` or `WaitForFirstConsumer` | `Immediate` |
| `storage.allowedTopologies.enabled` | Check [bevel-storageclass](../../../shared/charts/bevel-storageclass/README.md) for details  | `false`  |

### Tessera
This is where you can override the values for the [besu-tessera-node subchart](../besu-tessera-node/README.md).

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `tessera.enabled` | Enable Privacy/Tessera for the Besu node  | `false` |

### Image
| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials  | `""`            |
| `image.pullPolicy`  | Pull policy to be used for the Docker images    | `IfNotPresent`    |
| `image.besu.repository`   | Besu image repository  | `hyperledger/besu`|
| `image.besu.tag`   | Besu image tag as per version of Besu  | `23.10.2`|
| `image.hooks.repository`  | Quorum/Besu hooks image repository  | `ghcr.io/hyperledger/bevel-k8s-hooks` |
| `image.hooks.tag`  | Quorum/Besu hooks image tag  | `qgt-0.2.12` |


### Besu node

This contains all the parameters for the Besu node. Please read [Hyperledger Besu documentation](https://besu.hyperledger.org/public-networks/reference/cli/options) for detailed explanation of each parameter.

| Name   | Description      | Default Value |
| ----------------| ----------- | ------------- |
| `node.removeKeysOnDelete` | Setting to delete the secrets when uninstalling the release  | `false` |
| `node.isBootnode` | Flag to treat the Besu node as a bootnode  | `false` |
| `node.usesBootnodes` | Set this to true if the network you are connecting to use a bootnode/s that are deployed in the cluster   | `false` |
| `node.besu.envBesuOpts` | Pass additional environment parameters here   | `""`  |
| `node.besu.resources.cpuLimit` | CPU Limit for Besu statefulset  | `0.7` |
| `node.besu.resources.cpuRequest`   | Initial CPU request for Besu statefulset | `0.5`         |
| `node.besu.resources.memLimit` | Memory Limit for Besu statefulset  | `2G`         |
| `node.besu.resources.memRequest`   | Initial Memory request for Besu statefulset | `1G`         |
| `node.besu.dataPath`   | Mount path for Besu PVC | `/data/besu`         |
| `node.besu.keysPath` | Mount path for Besu keys   | `/keys`    |
| `node.besu.privateKeyPath`   | Mount path for the Besu privatekeys | `/keys/nodekey` |
| `node.besu.genesisFilePath` | Path for the Genesis json file  | `/etc/genesis/genesis.json`    |
| `node.besu.logging`   | Logging setting for the Besu nodes | `INFO`         |
| `node.besu.account.password`   | Password for Besu Account key generation | `password`         |
| `node.besu.account.passwordPath` | Path where the password file will be stored   | `/keys/accountPassword`    |

### Common parameters

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `volumePermissionsFix` | fixes permissions of volumes because besu runs as user `besu` and volumes prefer `root`  | `- minikube`<br>`- aws`  |
| `labels.service` | Custom labels in yaml k-v format  | `[]`  |
| `labels.pvc` | Custom labels in yaml k-v format  | `[]`  |
| `labels.deployment` | Custom labels in yaml k-v format  | `[]`  |

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
