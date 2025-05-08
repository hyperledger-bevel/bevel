[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# indy-key-mgmt

This chart is a component of Hyperledger Bevel. The indy-key-mgmt chart generates the various keys needed for a Hyperledger Indy node. If enabled, the keys are then stored on the configured vault and stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install authority-keys bevel/indy-key-mgmt
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

> **Important**: Also check the dependent charts.

## Installing the Chart

To install the chart with the release name `authority-keys`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install authority-keys bevel/indy-key-mgmt
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `authority-keys` deployment:

```bash
helm uninstall authority-keys
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters
These parameters are referred to as same in each parent or child chart
| Name   | Description  | Default Value |
|--------|---------|-------------|
|`global.serviceAccountName` | The serviceaccount name that will be created for Vault Auth and k8S Secret management| `vault-auth` |
| `global.cluster.provider` | Kubernetes cluster provider like AWS EKS, AKS or minikube. Currently ony `aws`, `azure` and `minikube` is tested | `aws` |
| `global.cluster.cloudNativeServices` | only `false` is implemented, `true` to use Cloud Native Services (SecretsManager and IAM for AWS; KeyVault & Managed Identities for Azure) is for future  | `false`  |
| `global.cluster.kubernetesUrl` | URL of the Kubernetes Cluster  | `""`  |
| `global.vault.type`  | Type of Vault to support other providers. Currently, only `hashicorp` and `kubernetes` is supported. | `hashicorp`    |
| `global.vault.role`  | Role used for authentication with Vault | `vault-role`    |
| `global.vault.network`  | Network type that is being deployed | `indy`    |
| `global.vault.address`| URL of the Vault server.    | `""`            |
| `global.vault.authPath`    | Authentication path for Vault  | `authority`            |
| `global.vault.secretEngine` | The value for vault secret engine name   | `secretsv2`  |
| `global.vault.secretPrefix` | The value for vault secret prefix which must start with `data/`   | `data/authority`  |

### Image

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.keyUtils`  | Indy Key Gen image repository for the Indy version  | `ghcr.io/hyperledger/bevel-indy-key-mgmt:1.12.6` |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials  | `""`            |

### Settings

| Name   | Description  | Default Value |
|--------|---------|-------------|
|`settings.removeKeysOnDelete` | Setting to delete the keys when uninstalling the release | `true` |
| `settings.identities.trustee` | Single trustee identity to be created for the organization. Set to empty if not needed  | `authority-trustee` |
| `settings.identities.endorser` | Single endorser identity to be created for the organization. Set to empty if not needed  | `""` |
| `settings.identities.stewards` | Array of steward identities to be created for the orgnaization. Set to empty if not needed  | `[]` |

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
