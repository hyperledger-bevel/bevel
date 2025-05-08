[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# cenm idman-service

This chart is a component of Hyperledger Bevel. The cenm-idman chart deploys a R3 Corda Enterprise identity manager. If enabled, the keys are then stored on the configured vault and stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install idman bevel/cenm-idman
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

> **Important**: Ensure the `enterprise-init` chart has been installed before installing this. Also check the dependent charts. Installing this chart separately is not required as it is a dependent chart for cenm, and is installed with cenm chart.

## Installing the Chart

To install the chart with the release name `idman`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install idman bevel/cenm-idman
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `idman` deployment:

```bash
helm uninstall idman
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
| `global.proxy.externalUrlSuffix` | The External URL suffix at which the Besu P2P and RPC service will be available | `test.blockchaincloudpoc.com` |
| `global.cenm.sharedCreds.truststore` | The truststore password the pki created truststores | `password` |
| `global.cenm.sharedCreds.keystore` | The truststore password the pki created ketstores | `password` |
| `global.cenm.identityManager.port` | The port for identity manager issuance | `10000` |
| `global.cenm.identityManager.revocation.port` | The port for identity manager revocation | `5053` |
| `global.cenm.identityManager.internal.port` | The port for identity manager internal listener | `5052` |
| `global.cenm.auth.port` | The port for auth api | `8081` |
| `global.cenm.gateway.port` | The port for gateway api | `8080` |
| `global.cenm.zone.enmPort` | The port for zone ENM | `25000` |

### Storage

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `storage.allowedTopologies.enabled` | Check [bevel-storageclass](../../../shared/charts/bevel-storageclass/README.md) for details  | `false`  |


### Image
| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials  | `""`            |
| `image.pullPolicy`  | Pull policy to be used for the Docker images    | `IfNotPresent`    |
| `image.idman.repository`   | CENM idman image repository  | `corda/enterprise-idman`|
| `image.idman.tag`   | CENM idman image tag as per version | `1.5.9-zulu-openjdk8u382`|

### Database Settings
| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `database.driverClassName`    | DB drive class name  | `org.h2.Driver`            |
| `database.jdbcDriver`    | DB jdbc driver  | `""`            |
| `database.driverClassName`    | DB url  | `jdbc:h2:file:./h2/idman-persistence;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;WRITE_DELAY=0;AUTO_SERVER_PORT=0`            |
| `database.user`    | DB user name  | `idman-db-user`            |
| `database.password`    | DB password  | `idman-db-password`            |

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
