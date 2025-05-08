[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# corda enterprise node-service

This chart is a component of Hyperledger Bevel. The enterprise-node chart deploys a R3 Corda Enterprise node. If enabled, the keys are then stored on the configured vault and stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install node bevel/enterprise-node
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

> **Important**: Ensure the `enterprise-init`, `cenm`, chart has been installed before installing this. Also check the dependent charts.

## Installing the Chart

To install the chart with the release name `node`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install node bevel/enterprise-node
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `node` deployment:

```bash
helm uninstall node
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

### Storage

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `storage.size` | Size of the Volume needed node Service  | `1Gi` |
| `storage.dbSize` | Size of the Volume needed for h2  | `5Gi` |
| `storage.allowedTopologies.enabled` | Check [bevel-storageclass](../../../shared/charts/bevel-storageclass/README.md) for details  | `false`  |


### Image
| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials | `""`            |
| `image.pullPolicy`  | Pull policy to be used for the Docker images    | `IfNotPresent`    |
| `image.bevelAlpine.repository`   | Bevel alpine image repository  | `ghcr.io/hyperledger/bevel-alpine`|
| `image.bevelAlpine.tag`   | Bevel alpine image tag  | `latest`|
| `image.node.repository`  | node image repository  | `corda/corda-enterprise` |
| `image.node.tag`  | node image tag  | `4.10.3-zulu-openjdk8-alpine` |

### node nodeConf

| Name   | Description      | Default Value |
| ----------------| ----------- | ------------- |
| `nodeConf.creds.truststore` | Keystore password  | `cordacadevpass` |
| `nodeConf.creds.keystore` | Truststore password  | `trustpass` |
| `nodeConf.crlCheckSoftFail` | certificate revocation check fails silently  | `true` |
| `nodeConf.tlsCertCrlDistPoint` | tls cert certificate revocation list distribution point  | `""` |
| `nodeConf.tlsCertCrlIssuer` |  tls cert certificate issuer  | `""` |
| `nodeConf.devMode` | Flag for node dev mode  | `false` |
| `nodeConf.allowDevCorDapps.enabled` | Flag to allow dev corDapps  | `true` |
| `nodeConf.p2pPort` | node p2p port  | `10002` |
| `nodeConf.rpc.port` | node rpc port | `10003` |
| `nodeConf.rpc.adminPort` | node rpc admin port  | `10005` |
| `nodeConf.rpc.users` | node list of RPC users  | `list` |
| `nodeConf.ssh.enabled` | Enable node ssh service | `true` |
| `nodeConf.ssh.sshdPort` | node ssh port | `2222` |
| `nodeConf.removeKeysOnDelete` | Remove node keys on helm uninstallation  | `false` |
| `nodeConf.legalName` | node legal name | `O=node1,OU=node,L=London,C=GB` |
| `nodeConf.firewall.enabled` | Corda Enterprise node firewall enabled | `false` |

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
