[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# fabric-genesis

This chart is a component of Hyperledger Bevel. The fabric-genesis chart creates the genesis file and other channel artifacts for a Hyperfabric network. If enabled, the keys are then stored on the configured vault and stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install genesis bevel/fabric-genesis
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

The [Orderers](../fabric-orderernode/README.md) and [Peers](../fabric-peernode/README.md) should already be installed and this chart should generally be installed from the Orderer namespace as it has most of the admin permissions.

After the peers have been installed, get certificates and the configuration file of each peer organization, place in `fabric-genesis/files`
```bash
cd ./fabric-genesis/files
kubectl --namespace carrier-net get secret admin-msp -o json > carrier.json
kubectl --namespace carrier-net get configmap peer0-msp-config -o json > carrier-config-file.json
```

If additional orderer(s) from a different organization is needed in genesis, then get that TLS cert and place in `fabric-genesis/files`
```bash
cd ./fabric-genesis/files
kubectl --namespace carrier-net get secret orderer5-tls -o json > orderer5-orderer-tls.json
```

## Installing the Chart

To install the chart with the release name `genesis`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install genesis bevel/fabric-genesis
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `genesis` deployment:

```bash
helm uninstall genesis
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

These parameters are referred to as same in each parent or child chart
| Name   | Description  | Default Value |
|--------|---------|-------------|
| `global.version` | Fabric Version.| `2.5.4` |
| `global.serviceAccountName` | The serviceaccount name that will be created for Vault Auth and k8S Secret management| `vault-auth` |
| `global.cluster.provider` | Kubernetes cluster provider like AWS EKS or minikube. Currently ony `aws` and `minikube` is tested | `aws` |
| `global.cluster.cloudNativeServices` | only `false` is implemented, `true` to use Cloud Native Services (SecretsManager and IAM for AWS; KeyVault & Managed Identities for Azure) is for future  | `false`  |
| `global.vault.type`  | Type of Vault to support other providers. Currently, only `hashicorp` and `kubernetes` is supported. | `hashicorp`    |
| `global.vault.role`  | Role used for authentication with Vault | `vault-role`    |
| `global.vault.network`  | Network type that is being deployed | `fabric`    |
| `global.vault.address`| URL of the Vault server.    | `""`            |
| `global.vault.authPath`    | Authentication path for Vault  | `supplychain`            |
| `global.vault.secretEngine` | Vault secret engine name | `secretsv2`  |
| `global.vault.secretPrefix` | Vault secret prefix which must start with `data/`  | `data/supplychain`  |
| `global.proxy.provider` | The proxy or Ingress provider. Can be `none` or `haproxy` | `haproxy` |
| `global.proxy.externalUrlSuffix` | The External URL suffix at which the Fabric services will be available | `test.blockchaincloudpoc.com` |

### Image

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.fabricTools`  | Fabric Tools image repository  | `ghcr.io/hyperledger/bevel-fabric-tools` |
| `image.alpineUtils`  | Alpine utils image repository and tag | `ghcr.io/hyperledger/bevel-alpine:latest` |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials | `""`            |

### Organizations

List of Organizations participating in the Network with their Peer and Orderer Addresses.

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `organizations.name` | Organization Name | `supplychain` |
| `organizations.orderers` | List of organization's orderer nodes and their addresses. This list presents two fields `orderer.name` and `orderer.ordererAddress`  | `- name: orderer1`<br/>`ordererAddress: orderer1.supplychain-net:7050` <br/>`- name: orderer2`<br/>`ordererAddress: orderer2.supplychain-net:7050` <br/> `- name: orderer3`<br/>`ordererAddress: orderer3.supplychain-net:7050`  |
| `organizations.peers` | List of the organization's peer nodes and their addresses. This list presents two fields `peer.name` and `peer.peerAddress`  | `- name: peer0`<br/>`peerAddress: peer0.supplychain-net:7051`<br>`- name: peer1`<br/>`peerAddress: peer1.supplychain-net:7051`  |

### Consensus

| Name     | Description                 | Default Value   |
| ---------| ----------------------------| ----------------|
| `consensus` | Name of the consensus          | `raft`         |
| `kafka.brokers` | Array of Kafka broker Addresses, only valid for `kafka` consensus    | `""`   |


### Channels
List of Channels you want to create the artifacts for.

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `channels.name` | Name of the channel | `allchannel` |
| `channels.consortium`| Consortium Name  | `SupplyChainConsortium` |
| `channels.orderers` | List of orderer type organizations (from the list above) on the network  | `- supplychain`  |
| `channels.participants` | List of participating channel organizations (from the list above) on the network  | `- supplychain`<br/>`- carrier` |


### Settings

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `settings.generateGenesis` |  Flag to generate the syschannel genesis for Fabric 2.2.x | `true` |
| `settings.removeConfigMapOnDelete` |  Flag to delete the genesis ConfigMap when uninstalling the release | `true` |

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
