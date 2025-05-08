[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)
# bevel-vault-mgmt
This chart is a component of Hyperledger Bevel. The bevel-vault-mgmt chart adds the configurations required to store the crypto materials in Hashicorp Vault. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
kubectl create secret generic roottoken --from-literal=token=<vault-root-token>
helm repo add bevel https://hyperledger.github.io/bevel
helm install my-release bevel/bevel-vault-mgmt
```

## Prerequisites

- Kubernetes 1.19+
- HashiCorp Vault Server 1.13.1+
- Vault Root token available.
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
kubectl create secret generic roottoken --from-literal=token=<vault-root-token>
helm repo add bevel https://hyperledger.github.io/bevel
helm install my-release bevel/bevel-vault-mgmt
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
helm uninstall my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters
These parameters are referred to as same in each parent or child chart
| Name   | Description  | Default Value |
|--------|---------|-------------|
|`global.serviceAccountName` | The serviceaccount name that will be created for Vault Auth management| `vault-auth` |
| `global.cluster.cloudNativeServices` | only `false` is implemented, `true` to use Cloud Native Services (SecretsManager and IAM for AWS; KeyVault & Managed Identities for Azure) is for future  | `false`  |
| `global.cluster.kubernetesUrl` | Kubernetes server URL | `""` |
| `global.vault.type`  | The Vault type that is used. Can be `hashicorp` or `kubernetes` as of now | `hashicorp`    |
| `global.vault.role`  | Role used for authentication with Vault | `vault-role`    |
| `global.vault.address`| URL of the Vault server.    | `""`            |
| `global.vault.authPath`    | Authentication path for Vault  | `supplychain`            |
| `global.vault.network` | Network type which will determine the vault policy | `besu` |
| `global.vault.secretEngine` | Vault secret engine name   | `secretsv2`  |
| `global.vault.secretPrefix` | Vault secret prefix which must start with `data/`   | `data/supplychain`  |
| `global.vault.tls` | Enable or disable TLS for vault communication if value present or not | `""`  |

### Image

| Name  | Description| Default Value   |
|------------|-----------|---------|
| `image.repository`    | Docker image repo which will be used for this job | `ghcr.io/hyperledger/bevel-alpine`  |
| `image.tag` |  Docker image tag which will be used for this job | `latest` |
| `image.pullSecret` | Secret name in the namespace containing private image registry credentials | `""`  |

### Common parameters

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `labels` | Custom labels in yaml k-v format  | `""`  |

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
