[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# fabric-orderernode

This chart is a component of Hyperledger Bevel. The fabric-orderernode chart deploys a Orderer Node for Hyperledger Fabric blockchain network. If enabled, the keys are stored on the configured vault and stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install orderer1 bevel/fabric-orderernode
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

> **Important**: Also check the dependent charts.

## Installing the Chart

To install the chart with the release name `orderer1`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install orderer1 bevel/fabric-orderernode
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `orderer1` deployment:

```bash
helm uninstall orderer1
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global

These parameters are referred to as same in each parent or child chart
| Name   | Description  | Default Value |
|--------|---------|-------------|
|`global.version` | Fabric Version. | `2.5.4` |
|`global.serviceAccountName` | The serviceaccount name that will be created for Vault Auth and k8S Secret management| `vault-auth` |
| `global.cluster.provider` | Kubernetes cluster provider like AWS EKS or minikube. Currently ony `aws`, `azure` and `minikube` are tested | `aws` |
| `global.cluster.cloudNativeServices` | only `false` is implemented, `true` to use Cloud Native Services (SecretsManager and IAM for AWS; KeyVault & Managed Identities for Azure) is for future  | `false`  |
| `global.vault.type`  | Type of Vault to support other providers. Currently, only `hashicorp` and `kubernetes` is supported. | `hashicorp`    |
| `global.vault.role`  | Role used for authentication with Vault | `vault-role`    |
| `global.vault.address`| URL of the Vault server.    | `""`            |
| `global.vault.authPath`    | Authentication path for Vault  | `supplychain`            |
| `global.vault.secretEngine` | Vault secret engine name   | `secretsv2`  |
| `global.vault.secretPrefix` | Vault secret prefix which must start with `data/`   | `data/supplychain`  |
| `global.vault.tls` | Name of the Kubernetes secret which has certs to connect to TLS enabled Vault   | `""`  |
| `global.proxy.provider` | The proxy or Ingress provider. Can be `none` or `haproxy` | `haproxy` |
| `global.proxy.externalUrlSuffix` | The External URL suffix at which the Fabric GRPC services will be available | `test.blockchaincloudpoc.com` |

### Storage

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `storage.size` | Size of the PVC needed for Orderer Node | `512Mi` |
| `storage.reclaimPolicy` | Reclaim policy for the PVC. Choose from: `Delete` or `Retain` | `Delete` |
| `storage.volumeBindingMode` | Volume binding mode for the PVC. Choose from: `Immediate` or `WaitForFirstConsumer` | `Immediate` |
| `storage.allowedTopologies.enabled` | Check [bevel-storageclass](../../../shared/charts/bevel-storageclass/README.md) for details  | `false`  |

### Certs

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `certs.generateCertificates` | Flag to generate certificates for the Orderer Node | `true` |
| `certs.orgData.caAddress` | Address of the CA Server without https | `ca.supplychain-net:7051` |
| `certs.orgData.caAdminUser` | CA Admin Username  | `supplychain-admin` |
| `certs.orgData.caAdminPassword` | CA Admin Password  | `supplychain-adminpw` |
| `certs.orgData.orgName` | Organization Name  | `supplychain` |
| `certs.orgData.type` | Type of certificate to generate, choosed from `orderer` or `peer` | `orderer` |
| `certs.orgData.componentSubject` | X.509 subject for the organization  | `"O=Orderer,L=51.50/-0.13/London,C=GB"` |
| `certs.settings.createConfigMaps` | Flag to create configmaps. Must be set to `false` for additional orderers/peers in the same organization. | `true` |
| `certs.settings.refreshCertValue` | Flag to refresh User certificates  | `false` |
| `certs.settings.addPeerValue` | Flag to be used when adding a new peer to the organization  | `false` |
| `certs.settings.removeCertsOnDelete` | Flag to delete the user and peer certificates on uninstall  | `false` |
| `certs.settings.removeOrdererTlsOnDelete` | Flag to delete the orderer TLS certificates on uninstall | `false` |

### Image

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.orderer`  |Fabric Orderer image repository | `ghcr.io/hyperledger/bevel-fabric-orderer` |
| `image.alpineUtils`  | Alpine utils image repository and tag | `ghcr.io/hyperledger/bevel-alpine:latest` |
| `image.healthCheck`  | Busybox image repository and tag  | `busybox` |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials | `""`            |

### Orderer

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `orderer.consensus` | Consensus type for the Orderer Node | `raft` |
| `orderer.logLevel` | Log level for the Orderer Node | `info` |
| `orderer.localMspId` | Local MSP ID for the Orderer Organization  | `supplychainMSP` |
| `orderer.tlsStatus` | TLS status of the Orderer Node  | `true` |
| `orderer.keepAliveServerInterval` | Keep Alive Interval in Seconds  | `10s` |
| `orderer.serviceType` | Service Type for the Ordering Service  | `ClusterIP` |
| `orderer.ports.grpc.nodePort` | NodePort for the Orderer GRPC Service  | `""` |
| `orderer.ports.grpc.clusterIpPort` | TCP Port for the Orderer GRPC Service  | `7050` |
| `orderer.ports.metrics.enabled` | Flag to enable metrics port  | `false` |
| `orderer.ports.metrics.clusterIpPort` | TCP Port for the Orderer metrics | `9443` |
| `orderer.resources.limits.memory` | Memory limit for the Orderer Node  | `512M` |
| `orderer.resources.limits.cpu` | CPU limit for the Orderer Node  | `1` |
| `orderer.resources.requests.memory` | Memory request for the Orderer Node  | `512M` |
| `orderer.resources.requests.cpu` | CPU request for the Orderer Node  | `0.25` |

### Settings

| Name   | Description      | Default Value |
| ----------------| ----------- | ------------- |
| `kafka.readinessCheckInterval` | Interval between readiness checks for the Brokers  | `5` |
| `kafka.readinessThresHold` | Threshold for readiness checks for the Brokers  | `1` |
| `kafka.brokers` | List of Kafka Broker Addresses  | `""` |
| `healthCheck.retries` | Retry count to connect to Vault  | `20` |
| `healthCheck.sleepTimeAfterError` | Wait seconds after unsuccessful connection attempt  | `15` |

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
