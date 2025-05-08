[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# quorum-node

This chart is a component of Hyperledger Bevel. The quorum-node chart deploys a Hyperledger quorum node with different settings like validator or member. If enabled, the keys are then stored on the configured vault and stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install validator-1 bevel/quorum-node
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

> **Important**: Ensure the `quorum-genesis` chart has been installed before installing this. Also check the dependent charts.

## Installing the Chart

To install the chart with the release name `validator-1`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install validator-1 bevel/quorum-node
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
This is where you can override the values for the [quorum-tessera-node subchart](../quorum-tessera-node/README.md).

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `tessera.enabled` | Enable Privacy/Tessera for the quorum node  | `false` |

### TLS
This is where you can override the values for the [quorum-tessera-node subchart](../quorum-tessera-node/README.md).

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `tls.enabled` | Enable secure access to Tessera node via HTTPS  | `false` |

### Image
| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.quorum.repository`   | Besu image repository  | `quorumengineering/quorum`|
| `image.quorum.tag`   | Besu image tag as per version of Besu  | `22.7.1`|
| `image.hooks.repository`  | Quorum/Besu hooks image repository  | `ghcr.io/hyperledger/bevel-k8s-hooks` |
| `image.hooks.tag`  | Quorum/Besu hooks image tag  | `qgt-0.2.12` |
| `image.pullPolicy`  | Pull policy to be used for the Docker images    | `IfNotPresent`    |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials  | `""`            |


### quorum node

This contains all the parameters for the quorum node. Please read [Hyperledger quorum documentation](https://besu.hyperledger.org/public-networks/reference/cli/options) for detailed explanation of each parameter.

| Name                                      | Description                                          | Default Value |
|-------------------------------------------|------------------------------------------------------|---------------|
| `node.quorum.resources.cpuLimit`       | CPU Limit for quorum statefulset                    | `0.7`         |
| `node.quorum.resources.cpuRequest`     | Initial CPU request for quorum statefulset          | `0.5`         |
| `node.quorum.resources.memLimit`       | Memory Limit for quorum statefulset                 | `2G`          |
| `node.quorum.resources.memRequest`     | Initial Memory request for quorum statefulset       | `1G`          |
| `node.quorum.dataPath`                 | Mount path for quorum PVC                           | `data` |
| `node.quorum.logging`                  | Logging setting for the quorum nodes                | `INFO`        |
| `node.quorum.account.password`         | Password for quorum Account key generation          | `password`    |
| `node.quorum.account.passwordPath`     | Path where the password file will be stored           | `data/keystore/accountPassword` |
| `node.quorum.log.verbosity`            | Log verbosity setting for quorum nodes              | `5`           |
| `node.quorum.miner.threads`            | Number of mining threads for quorum nodes           | `1`           |
| `node.quorum.miner.blockPeriod`        | Block period for quorum nodes                       | `5`           |
| `node.quorum.p2p.enabled`              | Enable P2P communication for quorum nodes           | `true`        |
| `node.quorum.p2p.addr`                 | P2P address for quorum nodes                        | `0.0.0.0`     |
| `node.quorum.p2p.port`                 | P2P port for quorum nodes                           | `30303`       |
| `node.quorum.rpc.enabled`              | Enable RPC for quorum nodes                         | `true`        |
| `node.quorum.rpc.addr`                 | RPC address for quorum nodes                        | `0.0.0.0`     |
| `node.quorum.rpc.port`                 | RPC port for quorum nodes                           | `8545`        |
| `node.quorum.rpc.corsDomain`           | CORS domain for quorum RPC                          | `*`           |
| `node.quorum.rpc.vHosts`               | Virtual hosts for quorum RPC                        | `*`           |
| `node.quorum.rpc.api`                  | Enabled APIs for quorum RPC                         | `admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul` |
| `node.quorum.rpc.authenticationEnabled`| Enable authentication for quorum RPC                | `false`       |
| `node.quorum.ws.enabled`                    | Enable WebSocket communication for quorum nodes     | `true`        |
| `node.quorum.ws.addr`                       | WebSocket address for quorum nodes                  | `0.0.0.0`     |
| `node.quorum.ws.port`                       | WebSocket port for quorum nodes                     | `8546`        |
| `node.quorum.ws.api`                        | Enabled APIs for quorum WebSocket                   | `admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul` |
| `node.quorum.ws.origins`                    | Allowed origins for quorum WebSocket                | `*`           |
| `node.quorum.ws.authenticationEnabled`      | Enable authentication for quorum WebSocket          | `false`       |
| `node.quorum.graphql.enabled`               | Enable GraphQL API for quorum nodes                 | `true`        |
| `node.quorum.graphql.addr`                  | GraphQL address for quorum nodes                    | `0.0.0.0`     |
| `node.quorum.graphql.port`                  | GraphQL port for quorum nodes                       | `8547`        |
| `node.quorum.graphql.corsDomain`            | CORS domain for quorum GraphQL                      | `*`           |
| `node.quorum.graphql.vHosts`                | Virtual hosts for quorum GraphQL                    | `*`           |
| `node.quorum.metrics.enabled`               | Enable metrics collection for quorum nodes           | `true`        |
| `node.quorum.metrics.pprofaddr`             | Address for accessing pprof endpoints for metrics      | `0.0.0.0`     |
| `node.quorum.metrics.pprofport`             | Port for accessing pprof endpoints for metrics         | `9545`        |
| `node.quorum.metrics.serviceMonitorEnabled` | Enable ServiceMonitor for Prometheus integration      | `false`       |
| `node.quorum.privacy.url`                  | URL for Tessera privacy manager                        | `http://localhost:9101` |
| `node.quorum.privacy.pubkeysPath`          | Path for Tessera public keys                          | `/tessera`    |
| `node.quorum.privacy.pubkeyFile`           | File containing Tessera public key                    | `/tessera/tm.pub` |

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
