[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# corda-node

This chart is a component of Hyperledger Bevel. The corda-node chart deploys a R3 Corda Opens-source node with different settings like notary or node. If enabled, the keys are then stored on the configured vault and stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install notary bevel/corda-node
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

> **Important**: Ensure the `corda-init` chart has been installed before installing this. Also check the dependent charts.

## Installing the Chart

To install the chart with the release name `notary`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install notary bevel/corda-node
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `notary` deployment:

```bash
helm uninstall notary
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
| `global.proxy.p2p` | The external port at which the Corda P2P service will be available. This port must be unique for a single cluster and enabled on Ambassador. | `15010` |

### Storage

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `storage.size` | Size of the Volume needed for Corda node  | `1Gi` |
| `storage.dbSize` | Size of the Volume needed for H2 Database node | `2Gi` |
| `storage.allowedTopologies.enabled` | Check [bevel-storageclass](../../../shared/charts/bevel-storageclass/README.md) for details  | `false`  |

### TLS
This is where you can override the values for the [corda-certs-gen subchart](../corda-certs-gen/README.md).

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `tls.enabled` | Flag to enable TLS and certificate generation  | `true` |

### Image
| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials | `""`            |
| `image.pullPolicy`  | Pull policy to be used for the Docker images    | `IfNotPresent`    |
| `image.h2`   | H2 DB image repository and tag  | `ghcr.io/hyperledger/h2:2018`|
| `image.corda.repository`   | Corda Image repository  | `ghcr.io/hyperledger/bevel-corda`|
| `image.corda.tag`   | Corda image tag as per version of Corda  | `4.9`|
| `image.initContainer` | Image repository and tag for alpine container | `ghcr.io/hyperledger/bevel-alpine:latest` |
| `image.hooks.repository`  | Corda hooks image repository  | `ghcr.io/hyperledger/bevel-build` |
| `image.hooks.tag`  | Corda hooks image tag  | `jdk8-stable` |


### Corda nodeConf

This contains all the parameters for the Corda node. Please read [R3 Corda documentation](https://docs.r3.com/en/platform/corda/4.9/community/corda-configuration-fields.html) for detailed explanation of each parameter.

| Name   | Description      | Default Value |
| ----------------| ----------- | ------------- |
| `nodeConf.defaultKeystorePassword` | Default Keystore password, do not change this  | `cordacadevpass` |
| `nodeConf.defaultTruststorePassword` | Default Truststore password, do not change this  | `trustpass` |
| `nodeConf.keystorePassword` | New keystore password which will be set after initialisation   | `newpass` |
| `nodeConf.truststorePassword` | New truststore password which will be set after initialisation  | `newtrustpass`  |
| `nodeConf.sslkeyStorePassword` | SSL keystore password which will be set after initialisation   | `sslpass` |
| `nodeConf.ssltrustStorePassword` | SSL truststore password which will be set after initialisation  | `ssltrustpass`  |
| `nodeConf.removeKeysOnDelete` | Flag to delete the keys when the release is uninstalled  | `true`  |
| `nodeConf.rpcUser` | Array of RPC Users that you want to create at initialization  | `- name: nodeoperations` <br>`password: nodeoperationsAdmin` <br>`permissions: [ALL]` |
| `nodeConf.p2pPort`   | P2P Port for Corda Node | `10002`         |
| `nodeConf.rpcPort` | RPC Port for Corda Node | `10003`         |
| `nodeConf.rpcadminPort`   | RPC Admin Port for Corda Node | `10005`         |
| `nodeConf.rpcSettings.useSsl`   | Use SSL for RPC | `false`         |
| `nodeConf.rpcSettings.standAloneBroker` | Standalone Broker setting for RPC   | `false`    |
| `nodeConf.rpcSettings.address`   | Address for RPC Service | `"0.0.0.0:10003"` |
| `nodeConf.rpcSettings.adminAddress` | Address for RPC Admin Service  | `"0.0.0.0:10005"`    |
| `nodeConf.rpcSettings.ssl.certificatesDirectory`   | SSL Certificate directory when useSSl is `true` | `na-ssl-false`         |
| `nodeConf.rpcSettings.ssl.sslKeystorePath`   | SSL Keystore path when useSSl is `true` | `na-ssl-false`         |
| `nodeConf.rpcSettings.ssl.trustStoreFilePath` | SSL Truststore path when useSSl is `true` | `na-ssl-false`    |
| `nodeConf.legalName`   | X.509 Subject for Corda Node Identity. Must be unique for different nodes in a network | `"O=Notary,OU=Notary,L=London,C=GB"`         |
| `nodeConf.messagingServerAddress` | Messaging Server Address | `""`         |
| `nodeConf.jvmArgs`   | Additional JVM Args | `""`         |
| `nodeConf.systemProperties`   | Additional System properties | `""`         |
| `nodeConf.sshd.port` | SSHD Admin port | `""`         |
| `nodeConf.exportJMXTo`   | JMX Reporter Address | `""`         |
| `nodeConf.transactionCacheSizeMegaBytes` | Specify how much memory should be used for caching of ledger transactions in memory (in MB) | `8`         |
| `nodeConf.attachmentContentCacheSizeMegaBytes`   | Specify how much memory should be used to cache attachment contents in memory (in MB) | `10`         |
| `nodeConf.notary.enabled`   | Enable this Corda node as a Notary | `true`         |
| `nodeConf.notary.validating` | Flag to setup validating or non-validating notary | `true`         |
| `nodeConf.notary.serviceLegalName`   | Specify the legal name of the notary cluster or node | `"O=Notary Service,OU=Notary,L=London,C=GB"` |
| `nodeConf.detectPublicIp` | Flag to detect public IP | `false`         |
| `nodeConf.database.exportHibernateJMXStatistics`   | Whether to export Hibernate JMX statistics | `false`         |
| `nodeConf.dbPort`   | Database port | `9101`         |
| `nodeConf.dataSourceUser` | Database username | `sa`         |
| `nodeConf.dataSourcePassword`   | Database user password | `admin`         |
| `nodeConf.dataSourceClassName`   | JDBC Data Source class name | `"org.h2.jdbcx.JdbcDataSource"`         |
| `nodeConf.jarPath` | Additional Jar path| `"/data/corda-workspace/h2/bin"`         |
| `nodeConf.networkMapURL`   | Root address of the network map service. | `https://supplychain-nms.supplychain-ns`         |
| `nodeConf.doormanURL`   | Root address of the doorman service | `https://supplychain-doorman.supplychain-ns`         |
| `nodeConf.devMode`   | Flag to set the node to run in development mode. | `false`         |
| `nodeConf.javaOptions`   | Additional JAVA_OPTIONS for Corda  | `"-Xmx512m"`         |

### CordApps

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `cordApps.getCordApps` | Flag to download CordApps from urls provided  | `false`  |
| `cordApps.jars` | List of `url`s from where the CordApps will be downloaded  | `- url: ""`  |

### Resources

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `resources.db.memLimit` | Kubernetes Memory limit for H2 Database pod  | `1G`  |
| `resources.db.memRequest` | Kubernetes Memory request for H2 Database pod  | `512M`  |
| `resources.node.memLimit` | Kubernetes Memory limit for Corda pod  | `2G`  |
| `resources.node.memRequest` | Kubernetes Memory request for Corda pod  | `1G`  |


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
