[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# besu-tlscert-gen

This chart is a component of Hyperledger Bevel. The besu-tlscert-gen chart generates the TLS certificates needed for accessing Besu and tessera nodes outside the cluster. If enabled, the certificates are then stored on the configured vault and also stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install my-release bevel/besu-tlscert-gen
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install my-release bevel/besu-tlscert-gen
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
These parameters are referred to as same in each parent or chold chart
| Name   | Description  | Default Value |
|--------|---------|-------------|
|`global.serviceAccountName` | The serviceaccount name that will be created for Vault Auth management| `vault-auth` |
| `global.vault.type`  | Type of Vault to support other providers. Currently, only `hashicorp` is supported. | `hashicorp`    |
| `global.vault.role`  | Role used for authentication with Vault | `vault-role`    |
| `global.vault.address`| URL of the Vault server.    | `""`            |
| `global.vault.authPath`    | Authentication path for Vault  | `supplychain`            |
| `global.vault.network` | Network type which will determine the vault policy | `besu` |
| `global.vault.secretEngine` | Vault secret engine name   | `secretsv2`  |
| `global.vault.secretPrefix` | Vault secret prefix which must start with `data/`   | `data/supplychain`  |
| `global.proxy.externalUrlSuffix` | External URL suffix which will be used as CN to generate certificate | `test.blockchaincloudpoc.com`  |

### Image

| Name  | Description| Default Value   |
|------------|-----------|---------|
| `image.repository`    | Docker repository which will be used for this job | `ghcr.io/hyperledger/bevel-alpine`  |
| `image.tag`    | Docker image tag which will be used for this job | `latest`  |
| `image.pullSecret` | Secret name in the namespace containing private image registry credentials   | `""`  |
| `image.pullPolicy` | The pull policy for the image  | `IfNotPresent`  |

### Settings
| Name | Description | Default Value   |
| ------------| -------------- | --------------- |
| `settings.tmTls`   | Set value to true when transaction manager like tessera uses tls. This enables TLS for the transaction manager and Besu node. | `True` |
| `settings.certSubject`  | The X.509 subject for root CA | `"CN=DLT Root CA,OU=DLT,O=DLT,L=London,C=GB"`            |

### Common parameters

| Name   | Description  | Default Value |
|--------|---------|-------------|
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
