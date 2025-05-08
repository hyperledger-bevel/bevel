[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# besu-genesis

This chart is a component of Hyperledger Bevel. The besu-genesis chart creates the genesis file for Besu network. If enabled, the keys are then stored on the configured vault and stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install genesis bevel/besu-genesis
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

> **Important**: Also check the dependent charts.

## Installing the Chart

To install the chart with the release name `genesis`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install genesis bevel/besu-genesis
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `genesis` deployment:

```bash
helm uninstall genesis
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters
These parameters are referred to as same in each parent or child chart
| Name   | Description  | Default Value |
|--------|---------|-------------|
|`global.serviceAccountName` | The serviceaccount name that will be created for Vault Auth and k8S Secret management| `vault-auth` |
| `global.cluster.provider` | Kubernetes cluster provider like AWS EKS or minikube. Currently only `aws`, `azure` and `minikube` are tested | `aws` |
| `global.cluster.cloudNativeServices` | only `false` is implemented, `true` to use Cloud Native Services (SecretsManager and IAM for AWS; KeyVault & Managed Identities for Azure) is for future  | `false`  |
| `global.cluster.kubernetesUrl` | URL of the Kubernetes Cluster  | `""`  |
| `global.vault.type`  | Type of Vault to support other providers. Currently, only `hashicorp` and `kubernetes` is supported. | `hashicorp`    |
| `global.vault.role`  | Role used for authentication with Vault | `vault-role`    |
| `global.vault.network`  | Network type that is being deployed | `besu`    |
| `global.vault.address`| URL of the Vault server.    | `""`            |
| `global.vault.authPath`    | Authentication path for Vault  | `supplychain`            |
| `global.vault.secretEngine` | The value for vault secret engine name   | `secretsv2`  |
| `global.vault.secretPrefix` | The value for vault secret prefix which must start with `data/`   | `data/supplychain`  |

### Image

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.genesisUtils.repository`  | Quorum/Besu hooks image repository  | `ghcr.io/hyperledger/bevel-k8s-hooks` |
| `image.genesisUtils.tag`  | Quorum/Besu hooks image tag  | `qgt-0.2.12` |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials  | `""`            |
| `image.pullPolicy`  | Pull policy to be used for the Docker images    | `IfNotPresent`    |

### Settings

| Name   | Description  | Default Value |
|--------|---------|-------------|
|`settings.removeGenesisOnDelete` | Setting to delete the genesis configmaps when uninstalling the release | `true` |
| `settings.secondaryGenesis` | Flag to copy genesis and static nodes from `files` for secondary members  | `false` |

### Genesis Config

| Name   | Description      | Default Value |
| ----------------| ----------- | ------------- |
| `rawGenesisConfig.genesis.config.chainId` | Chain Id of the Besu network  | `1337` |
| `rawGenesisConfig.genesis.config.algorithm.consensus`   | Consensus mechanism of the Besu network. Choose from: `ibft2`, `qbft`, `clique` | `qbft`         |
| `rawGenesisConfig.genesis.config.algorithm.blockperiodseconds` | Block period in seconds   | `10`    |
| `rawGenesisConfig.genesis.config.algorithm.epochlength`   | Epoch length  | `30000` |
| `rawGenesisConfig.genesis.config.algorithm.requesttimeoutseconds` | Request timeout in seconds  | `20` |
| `rawGenesisConfig.genesis.gasLimit`   | Gas limit for each transaction | `'0xf7b760'`         |
| `rawGenesisConfig.genesis.difficulty` | Difficulty setting  | `'0x1'`         |
| `rawGenesisConfig.genesis.coinbase`   | Coinbase setting | `'0x0000000000000000000000000000000000000000'`         |
| `rawGenesisConfig.genesis.includeQuickStartAccounts`   | Flag to include default accounts | `false`         |
| `rawGenesisConfig.genesis.initialContractDeployment.enabled`   | Flag to enable initial contract deployment | `false`         |
| `rawGenesisConfig.blockchain.nodes.generate` | Flag to generate the initial nodes as per the `count` below   | `true`    |
| `rawGenesisConfig.blockchain.nodes.count`   | Number of validators/signers. | `4` |
| `rawGenesisConfig.blockchain.accountPassword` | Default password for the new accounts   | `'password'`    |

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
