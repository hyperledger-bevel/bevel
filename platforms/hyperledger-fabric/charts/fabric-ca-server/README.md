[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# fabric-ca-server

This chart is a component of Hyperledger Bevel. The fabric-ca-server chart deploys a CA server for Hyperledger Fabric blockchain network. If enabled, the keys are then stored on the configured vault and stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install ca bevel/fabric-ca-server
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

> **Important**: Also check the dependent charts.

## Installing the Chart

To install the chart with the release name `ca`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install ca bevel/fabric-ca-server
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `ca` deployment:

```bash
helm uninstall ca
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
| `global.cluster.kubernetesUrl` | URL of the Kubernetes Cluster  | `""`  |
| `global.vault.type`  | Type of Vault to support other providers. Currently, only `hashicorp` and `kubernetes` is supported. | `hashicorp`    |
| `global.vault.role`  | Role used for authentication with Vault | `vault-role`    |
| `global.vault.network`  | Network type that is being deployed | `fabric`    |
| `global.vault.address`| URL of the Vault server.    | `""`            |
| `global.vault.authPath`    | Authentication path for Vault  | `supplychain`            |
| `global.vault.secretEngine` | Vault secret engine name   | `secretsv2`  |
| `global.vault.secretPrefix` | Vault secret prefix which must start with `data/`   | `data/supplychain`  |
| `global.vault.tls` | Name of the Kubernetes secret which has certs to connect to TLS enabled Vault   | `false`  |
| `global.proxy.provider` | The proxy or Ingress provider. Can be `none` or `haproxy` | `haproxy` |
| `global.proxy.externalUrlSuffix` | The External URL suffix at which the Fabric GRPC services will be available | `test.blockchaincloudpoc.com` |

### Storage

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `storage.size` | Size of the PVC needed for Fabric CA  | `512Mi` |
| `storage.reclaimPolicy` | Reclaim policy for the PVC. Choose from: `Delete` or `Retain` | `Delete` |
| `storage.volumeBindingMode` | Volume binding mode for the PVC. Choose from: `Immediate` or `WaitForFirstConsumer` | `Immediate` |
| `storage.allowedTopologies.enabled` | Check [bevel-storageclass](../../../shared/charts/bevel-storageclass/README.md) for details  | `false`  |

### Image

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.alpineUtils`  | Alpine utils image repository and tag | `ghcr.io/hyperledger/bevel-alpine:latest` |
| `image.ca`  | Fabric CA image repository and tag  | `ghcr.io/hyperledger/bevel-fabric-ca:latest` |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials | `""`            |

### Server

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `server.removeCertsOnDelete` | Flag to delete the certificate secrets when uninstalling the release | `true` |
| `server.tlsStatus` | TLS status of the server  | `true` |
| `server.adminUsername` | CA Admin Username  | `admin` |
| `server.adminPassword` | CA Admin Password  | `adminpw` |
| `server.subject` | CA server root subject  | `"/C=GB/ST=London/L=London/O=Orderer"` |
| `server.configPath` | Local path to the CA server configuration file which will be mounted to the CA Server  | `""` |
| `server.nodePort` | NodePort for the CA Server  | `""` |
| `server.clusterIpPort` | TCP Port for the CA Server   | `7054` |

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
