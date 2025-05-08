[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# indy-genesis

This chart is a component of Hyperledger Bevel. The indy-genesis chart creates the domain_transactions_genesis and pool_transaction_genesis files as Kubernetes config maps for Indy network. If enabled, the genesis files are then stored on the configured vault. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

> **Important**: All the public key files should already be placed in `files` before installing this chart. Check **Prerequisites**.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install genesis bevel/indy-genesis
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

Before running indy-genesis, the public key information for each trustee and steward should be saved in the `files` directory. For example, given a trustee called `authority-trustee` and a steward called `university-steward-1`, run the following commands to save the public key info. 

> **Important**: The [indy-key-mgmt](../indy-key-mgmt/README.md) chart generates these keys, so should be installed before this chart.

```bash
cd files
# trustee files are in authority-ns namespace
trustee_namespace=authority-ns
trustee_name=authority-trustee
kubectl --namespace $trustee_namespace get secret $trustee_name-identity-public -o jsonpath='{.data.value}' | base64 -d | jq '.["did"]'> $trustee_name-did.json
kubectl --namespace $trustee_namespace get secret $trustee_name-node-public-verif-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["verification-key"]' > $trustee_name-verkey.json

# steward files are in university-ns namespace
steward_namespace=university-ns
steward_name=university-steward-1
kubectl --namespace $steward_namespace get secret $steward_name-identity-public -o jsonpath='{.data.value}' | base64 -d | jq '.["did"]'> $steward_name-did.json
kubectl --namespace $steward_namespace get secret $steward_name-node-public-verif-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["verification-key"]' > $steward_name-verkey.json
kubectl --namespace $steward_namespace get secret $steward_name-node-public-bls-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["bls-key-pop"]' > $steward_name-blspop.json
kubectl --namespace $steward_namespace get secret $steward_name-node-public-bls-keys -o jsonpath='{.data.value}' | base64 -d | jq '.["bls-public-key"]' > $steward_name-blspub.json
```

## Installing the Chart

To install the chart with the release name `genesis`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install genesis bevel/indy-genesis
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
| `global.cluster.provider` | Kubernetes cluster provider like AWS EKS or minikube. Currently ony `aws`, `azure` and `minikube` is tested | `aws` |
| `global.cluster.cloudNativeServices` | only `false` is implemented, `true` to use Cloud Native Services (SecretsManager and IAM for AWS; KeyVault & Managed Identities for Azure) is for future  | `false`  |
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
| `image.alpineutils`  | Alpine utils image repository  | `ghcr.io/hyperledger/bevel-alpine-ext:latest` |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials  | `""`            |

### Settings

| Name   | Description  | Default Value |
|--------|---------|-------------|
|`settings.removeGenesisOnDelete` | Setting to delete the genesis configmaps when uninstalling the release | `true` |
| `settings.secondaryGenesis` | Flag to copy genesis and static nodes from `files` for secondary members  | `false` |
| `settings.trustees` | Array of trustees and the relatedß stewards with IP and port details | `- name: authority-trustee`<br>&nbsp;&nbsp;`stewards:` <br>&nbsp;&nbsp;`- name: university-steward-1` <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `publicIp:` <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `clientPort: 15011` <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; `nodePort: 15012` |

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
