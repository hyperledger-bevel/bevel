[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# besu-tessera-node

This chart is a component of Hyperledger Bevel. The besu-tessera-node chart deploys a tessera node with separate Mysql database. If enabled, the keys are then stored on the configured vault and stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install my-tessera bevel/besu-tessera-node
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

> **Important**: Also check the dependent charts.

## Installing the Chart

To install the chart with the release name `my-tessera`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install my-tessera bevel/besu-tessera-node
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-tessera` deployment:

```bash
helm uninstall my-tessera
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
| `global.proxy.externalUrlSuffix` | The External URL suffix at which the tessera service will be available | `test.blockchaincloudpoc.com` |
| `global.proxy.tmport` | The external port at which the tessera service will be available. This port must match `tessera.port` | `443` |

### Storage

| Name   | Description  | Default Value |
|--------|---------|-------------|
|`storage.enabled` | To enable new storage class for Tessera node | `true` |
| `storage.size` | Size of the PVC needed for Tessera  | `1Gi` |
| `storage.dbSize` | Size of the PVC needed for the MySql DB  | `1Gi`  |
| `storage.allowedTopologies.enabled` | Check [bevel-storageclass](../../../shared/charts/bevel-storageclass/README.md) for details  | `false`  |

### Image

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.alpineutils.repository`   | Alpine utils image repository  | `ghcr.io/hyperledger/bevel-alpine-ext`  |
| `image.alpineutils.tag`   | Alpine utils image tag  | `latest`  |
| `image.tessera.repository`   | Tessera image repository  | `quorumengineering/tessera`|
| `image.tessera.tag`   | Tessera image tag as per version of Tessera  | `22.1.7`|
| `image.busybox`| Repo and default tag for busybox image | `busybox` |
| `image.mysql.repository`  | MySQL image repository. This is used as the DB for TM  | `mysql/mysql-server` |
| `image.mysql.tag`  | MySQL image tag  | `5.7` |
| `image.hooks.repository`  | Quorum/Besu hooks image repository  | `ghcr.io/hyperledger/bevel-k8s-hooks` |
| `image.hooks.tag`  | Quorum/Besu hooks image tag  | `qgt-0.2.12` |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials  | `""`            |
| `image.pullPolicy`  | Pull policy to be used for the Docker images    | `IfNotPresent`    |


### Tessera

| Name   | Description      | Default Value |
| ----------------| ----------- | ------------- |
| `tessera.removeKeysOnDelete` | Setting to delete the secrets when uninstalling the release  | `true` |
| `tessera.dbName`   | Name of the MySQL database | `demodb`         |
| `tessera.dbUsername` | MySQL Database username   | `demouser`    |
| `tessera.peerNodes`   | List of other tessera peer nodes like `- url: "https://node1.test.blockchaincloudpoc.com"`  | `""` |
| `tessera.resources.cpuLimit` | CPU Limit for tessera statefulset  | `1` |
| `tessera.resources.cpuRequest`   | Initial CPU request for tessera statefulset | `0.25`         |
| `tessera.resources.memLimit` | Memory Limit for tessera statefulset  | `2G`         |
| `tessera.resources.memRequest`   | Initial Memory request for tessera statefulset | `1G`         |
| `tessera.password`   | Password for tessera key generation | `password`         |
| `tessera.passwordPath` | Path where the password file will be stored   | `/keys/tm.password`    |
| `tessera.dataPath`   | Mount path for tessera PVC | `/data/tessera`         |
| `tessera.keysPath` | Mount path for Tessera keys   | `/keys`    |
| `tessera.port`   | Port at which Tessera service will run | `9000`         |
| `tessera.tpport` | Third party port   | `9080`    |
| `tessera.q2tport`   | Client port where besu nodes will connect | `9101`         |
| `tessera.dbport` | Port where MySQL service is running   | `3306`    |
| `tessera.metrics.enabled`   | Enable metrics and monitoring for Tessera node | `true`         |
| `tessera.metrics.host`   | Host where metrics will be available | `"0.0.0.0"`         |
| `tessera.metrics.port`   | Port where metrics will be available | `9545`         |
| `tessera.metrics.serviceMonitorEnabled`   | Enable service monitor | `false`         |
| `tessera.tlsMode`   | TLS mode for tessera. Options are `"STRICT"` or `"OFF"` | `"STRICT"`         |
| `tessera.trust`   | Server/Client trust configuration. Only for `STRICT` tlsMode. options are: `"WHITELIST"`, `"CA_OR_TOFU"`, `"CA"`, `"TOFU"`| `"CA_OR_TOFU"`         |


### TLS

| Name   | Description  | Default Value |
|--------|---------|-------------|
|`tls.enabled` | To enable TLS cert generation for Tessera node. | `true` |
| `tls.settings.tmTls` | Set the TLS setting for certificate generation. Must be enabled for `tlsMode: STRICT`  | `True` |
| `tls.settings.certSubject` | X.509 Subject for the Root CA  | `"CN=DLT Root CA,OU=DLT,O=DLT,L=London,C=GB"`  |

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
