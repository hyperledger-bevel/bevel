[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# fabric-catools

This chart is a component of Hyperledger Bevel. The fabric-catools chart creates job(s) to generate the certificates and keys required for Hyperledger Fabric network. If enabled, the keys are then stored on the configured vault and stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install catools bevel/fabric-catools
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

## Installing the Chart

To install the chart with the release name `catools`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install catools bevel/fabric-catools
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `catools` deployment:

```bash
helm uninstall catools
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters
These parameters are referred to as same in each parent or child chart
| Name   | Description  | Default Value |
|--------|---------|-------------|
|`global.serviceAccountName` | The serviceaccount name that will be created for Vault Auth and k8S Secret management| `vault-auth` |
| `global.cluster.provider` | Kubernetes cluster provider like AWS EKS or minikube. Currently ony `aws`, `azure` and `minikube` are tested | `aws` |
| `global.cluster.cloudNativeServices` | only `false` is implemented, `true` to use Cloud Native Services (SecretsManager and IAM for AWS; KeyVault & Managed Identities for Azure) is for future  | `false`  |
| `global.vault.type`  | Type of Vault to support other providers. Currently, only `hashicorp` and `kubernetes` is supported. | `hashicorp`    |
| `global.vault.role`  | Role used for authentication with Vault | `vault-role`    |
| `global.vault.address`| URL of the Vault server.    | `""`            |
| `global.vault.authPath`    | Authentication path for Vault  | `supplychain`            |
| `global.vault.secretEngine` | Vault secret engine name   | `secretsv2`  |
| `global.vault.secretPrefix` | Vault secret prefix which must start with `data/`   | `data/supplychain`  |
| `global.vault.tls` | Name of the Kubernetes secret which has certs to connect to TLS enabled Vault   | `false`  |
| `global.proxy.provider` | The proxy or Ingress provider. Can be `none` or `haproxy` | `haproxy` |
| `global.proxy.externalUrlSuffix` | The External URL suffix at which the Fabric GRPC services will be available | `test.blockchaincloudpoc.com` |

### Image

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.caTools`  | Fabric CA Tools image repository and tag  | `ghcr.io/hyperledger/bevel-fabric-ca:latest` |
| `image.alpineUtils`  | Alpine utils image repository and tag | `ghcr.io/hyperledger/bevel-alpine:latest` |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials | `""`            |
| `image.pullPolicy`    | Image pull policy | `IfNotPresent`            |

### OrgData

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `orgData.caAddress` | Address of the CA Server without https | `""` |
| `orgData.caAdminUser` | CA Admin Username  | `supplychain-admin` |
| `orgData.caAdminPassword` | CA Admin Password  | `supplychain-adminpw` |
| `orgData.orgName` | Organization Name  | `supplychain` |
| `orgData.type` | Type of certificate to generate, choosed from `orderer` or `peer` | `orderer` |
| `orgData.componentSubject` | X.509 subject for the organization  | `"O=Orderer,L=51.50/-0.13/London,C=GB"` |

### Users

| Name   | Description      | Default Value |
| ----------------| ----------- | ------------- |
| `users.usersList` | Array of Users with their attributes  | `- identity: user1`<br/>`attributes:`<br/>`- key: "hf.Revoker"`<br/>`value: "true"` |
| `users.usersListAnsible` | Base64 encoded list of Users generally passed from Ansible  | `""` |

### Settings

| Name   | Description      | Default Value |
| ----------------| ----------- | ------------- |
| `settings.createConfigMaps` | Flag to create configmaps. Must be set to `false` for additional orderers/peers in the same organization. | `true` |
| `settings.refreshCertValue` | Flag to refresh User certificates  | `false` |
| `settings.addPeerValue` | Flag to be used when adding a new peer to the organization  | `false` |
| `settings.removeCertsOnDelete` | Flag to delete the user and peer certificates on uninstall  | `false` |
| `settings.removeOrdererTlsOnDelete` | Flag to delete the orderer TLS certificates on uninstall | `false` |

### Labels

| Name   | Description      | Default Value |
| ----------------| ----------- | ------------- |
| `labels.service` | Array of Labels for service object  | `[]` |
| `labels.pvc` | Array of Labels for PVC object  | `[]` |
| `labels.deployment` | Array of Labels for deployment or statefulset object  | `[]` |

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
