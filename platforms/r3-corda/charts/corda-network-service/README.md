[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# corda-network-service

This chart is a component of Hyperledger Bevel. The corda-network-service chart deploys a R3 Corda Doorman, Networkmap and associated MongoDB database. If enabled, the keys are then stored on the configured vault and stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install network-service bevel/corda-network-service
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

> **Important**: Ensure the `corda-init` chart has been installed before installing this. Also check the dependent charts.

## Installing the Chart

To install the chart with the release name `network-service`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install network-service bevel/corda-network-service
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `network-service` deployment:

```bash
helm uninstall network-service
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters
These parameters are referred to as same in each parent or child chart
| Name   | Description  | Default Value |
|--------|---------|-------------|
|`global.serviceAccountName` | The serviceaccount name that will be used for Vault Auth management| `vault-auth` |
| `global.cluster.provider` | Kubernetes cluster provider like AWS EKS or minikube. Currently ony `aws` and `minikube` is tested | `aws` |
| `global.cluster.cloudNativeServices` | only `false` is implemented, `true` to use Cloud Native Services (SecretsManager and IAM for AWS; KeyVault & Managed Identities for Azure) is for future  | `false`  |
| `global.vault.type`  | Type of Vault to support other providers. Currently, only `hashicorp` is supported. | `hashicorp`    |
| `global.vault.role`  | Role used for authentication with Vault | `vault-role`    |
| `global.vault.address`| URL of the Vault server.    | `""`            |
| `global.vault.authPath`    | Authentication path for Vault  | `supplychain`            |
| `global.vault.secretEngine` | The value for vault secret engine name   | `secretsv2`  |
| `global.vault.secretPrefix` | The value for vault secret prefix which must start with `data/`   | `data/supplychain`  |
| `global.proxy.provider` | The proxy or Ingress provider. Can be `none` or `ambassador` | `ambassador` |
| `global.proxy.externalUrlSuffix` | The External URL suffix at which the Corda P2P service will be available | `test.blockchaincloudpoc.com` |

### Storage

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `storage.size` | Size of the Volume needed for NMS and Doorman node  | `1Gi` |
| `storage.dbSize` | Size of the Volume needed for MongoDB  | `1Gi` |
| `storage.allowedTopologies.enabled` | Check [bevel-storageclass](../../../shared/charts/bevel-storageclass/README.md) for details  | `false`  |

### TLS
This is where you can override the values for the [corda-certs-gen subchart](../corda-certs-gen/README.md).

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `tls.enabled` | Use TLS for all communcations  | `false` |
| `tls.settings.networkServices` | Enable TLS certificate generation for Doorman and NMS   | `true` |

### Image
| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials | `""`            |
| `image.pullPolicy`  | Pull policy to be used for the Docker images    | `IfNotPresent`    |
| `image.mongo.repository`   | MongoDB image repository  | `mongo`|
| `image.mongo.tag`   | MongoDB image tag as per version of MongoDB  | `3.6.6`|
| `image.hooks.repository`  | Corda hooks image repository  | `ghcr.io/hyperledger/bevel-build` |
| `image.hooks.tag`  | Corda hooks image tag  | `jdk8-stable` |
| `image.doorman`  | Corda Doorman image repository and tag  | `ghcr.io/hyperledger/bevel-doorman-linuxkit:latest` |
| `image.nms`  | Corda Network Map image repository and tag  | `ghcr.io/hyperledger/bevel-networkmap-linuxkit:latest` |

### Common Settings
| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `settings.removeKeysOnDelete`    | Flag to delete the secrets on uninstall  | `true`            |
| `settings.rootSubject`  | X.509 Subject for the Corda Root CA | `"CN=DLT Root CA,OU=DLT,O=DLT,L=New York,C=US"`    |
| `settings.mongoSubject`   | X.509 Subject for the MongoDB CA  | `"C=US,ST=New York,L=New York,O=Lite,OU=DBA,CN=mongoDB"`|
| `settings.dbPort`   | MongoDB Port | `27017`|

### Doorman

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `doorman.subject`    | X.509 Subject for the Doorman  | `"CN=Corda Doorman CA,OU=DOORMAN,O=DOORMAN,L=New York,C=US"`            |
| `doorman.username`  | Username of Doorman DB | `doorman`    |
| `doorman.authPassword`   | Password of `sa` user to access doorman admin api  | `admin`|
| `doorman.dbPassword`   | Password for Doorman DB | `newdbnm`|
| `doorman.port`   | Port for Doorman Service | `8080`|

### NMS

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `nms.subject`    | X.509 Subject for the NetworkMap  | `"CN=Network Map,OU=FRA,O=FRA,L=Berlin,C=DE"`            |
| `nms.username`  | Username of NetworkMap DB | `networkmap`    |
| `nms.authPassword`   | Password of `sa` user to access NetworkMap admin api  | `admin`|
| `nms.dbPassword`   | Password for NetworkMap DB | `newdbnm`|
| `nms.port`   | Port for NetworkMap Service | `8080`|

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
