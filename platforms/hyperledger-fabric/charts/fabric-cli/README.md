[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# fabric-cli

This chart is a component of Hyperledger Bevel. The fabric-cli chart deploys a Fabric CLI attached to a Peer node to the Kubernetes cluster. This chart is a dependency and is deployed by the [fabric-peernode](../fabric-peernode/README.md) chart. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install peer0-cli bevel/fabric-cli
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

## Installing the Chart

To install the chart with the release name `peer0-cli`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install peer0-cli bevel/fabric-cli
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `peer0-cli` deployment:

```bash
helm uninstall peer0-cli
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters
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
| `global.vault.tls` | Name of the Kubernetes secret which has certs to connect to TLS enabled Vault   | `false`  |

### Image

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.fabricTools`  | Fabric Tools image repository  | `ghcr.io/hyperledger/bevel-fabric-tools` |
| `image.alpineUtils`  | Alpine utils image repository and tag | `ghcr.io/hyperledger/bevel-alpine:latest` |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials | `""`            |

### Configuration

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `peerName` | Name of the Peer that this CLI will connect. Leave empty when created using `fabric-peernode` chart | `""` |
| `storageClass` | Storage Class for the cli, Storage Class should be already created by `fabric-peernode` chart. Pass existing storage class for independent CLI creation | `""` |
| `storageSize` | PVC Storage Size for the cli | `256Mi` |
| `localMspId` | Local MSP ID of the organization| `supplychainMSP` |
| `tlsStatus` | TLS status of the peer  | `true` |
| `ports.grpc.clusterIpPort` | GRPC Internal Port for Peer | `7051` |
| `ordererAddress` | Orderer Internal or External Address with port for CLI to connect  | `orderer1.supplychain-net:7050` |
| `healthCheck.retries` | Retry count to connect to the Peer  | `20` |
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
