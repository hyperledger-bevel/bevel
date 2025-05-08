[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# fabric-channel-create

This chart is a component of Hyperledger Bevel. The fabric-channel-create chart deploys a Kubernetes job to create a channel. This chart should be executed after the [fabric-genesis](../fabric-genesis/README.md) chart and the channeltx should be present in `files`. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install allchannel bevel/fabric-channel-create
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

Also, [fabric-genesis](../fabric-genesis/README.md) chart should be installed. Then you can get the channeltx with following commands:

```bash
cd ./fabric-channel-create/files
kubectl --namespace supplychain-net get configmap allchannel-channeltx -o jsonpath='{.data.allchannel-channeltx_base64}' > channeltx.json
```

## Installing the Chart

To install the chart with the release name `allchannel`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install allchannel bevel/fabric-channel-create
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `allchannel` deployment:

```bash
helm uninstall allchannel
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters
These parameters are referred to as same in each parent or child chart
| Name   | Description  | Default Value |
|--------|---------|-------------|
|`global.version` | Fabric Version. This chart is only used for `2.2.x` | `2.2.2` |
|`global.serviceAccountName` | The serviceaccount name that will be created for Vault Auth and k8S Secret management| `vault-auth` |
| `global.cluster.provider` | Kubernetes cluster provider like AWS EKS or minikube. Currently ony `aws`, `azure` and `minikube` are tested | `aws` |
| `global.cluster.cloudNativeServices` | only `false` is implemented, `true` to use Cloud Native Services (SecretsManager and IAM for AWS; KeyVault & Managed Identities for Azure) is for future  | `false`  |
| `global.vault.type`  | Type of Vault to support other providers. Currently, only `hashicorp` and `kubernetes` is supported. | `hashicorp`    |
| `global.vault.role`  | Role used for authentication with Vault | `vault-role`    |
| `global.vault.network`  | Network type that is being deployed | `fabric`    |
| `global.vault.address`| URL of the Vault server.    | `""`            |
| `global.vault.authPath`    | Authentication path for Vault  | `carrier`            |
| `global.vault.secretEngine` | Vault secret engine name   | `secretsv2`  |
| `global.vault.secretPrefix` | Vault secret prefix which must start with `data/`   | `data/carrier`  |
| `global.vault.tls` | Name of the Kubernetes secret which has certs to connect to TLS enabled Vault   | `false`  |

### Image

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.fabricTools`  | Fabric Tools image repository  | `ghcr.io/hyperledger/bevel-fabric-tools` |
| `image.alpineUtils`  | Alpine utils image repository and tag | `ghcr.io/hyperledger/bevel-alpine:latest` |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials | `""`            |

### Peer

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `peer.name` | Name of the Peer that is creating the channel | `peer0` |
| `peer.address` | Peer Internal or External Address with port | `peer0.carrier-net:7051` |
| `peer.localMspId` | Peer MSP ID   | `carrierMSP` |
| `peer.logLevel` | Peer Log Level  | `debug` |
| `peer.tlsStatus` | TLS status of the peer  | `true` |
| `peer.ordererAddress` | Orderer Internal or External Address with port for Peer to connect  | `orderer1.supplychain-net:7050` |

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
