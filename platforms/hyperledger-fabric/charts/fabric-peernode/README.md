[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# fabric-peernode

This chart is a component of Hyperledger Bevel. The fabric-peernode chart deploys a Peer Node for Hyperledger Fabric blockchain network. If enabled, the keys are stored on the configured vault and stored as Kubernetes secrets. See [Bevel documentation](https://hyperledger-bevel.readthedocs.io/en/latest/) for details.

## TL;DR

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install peer0 bevel/fabric-peernode
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

If Hashicorp Vault is used, then
- HashiCorp Vault Server 1.13.1+

> **Important**: Also check the dependent charts.

## Installing the Chart

To install the chart with the release name `peer0`:

```bash
helm repo add bevel https://hyperledger.github.io/bevel
helm install peer0 bevel/fabric-peernode
```

The command deploys the chart on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `peer0` deployment:

```bash
helm uninstall peer0
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
| `global.proxy.port` | The External Port on the proxy | `443` |

### Storage

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `storage.enabled` | Flag to enable Storage Class creation for the Peer, set to `false` when using same peer name in different organizations | `true` |
| `storage.peer` | Size of the PVC needed for Peer Node | `512Mi` |
| `storage.couchdb` | Size of the PVC needed for CouchDB Database | `512Mi` |
| `storage.reclaimPolicy` | Reclaim policy for the PVC. Choose from: `Delete` or `Retain` | `Delete` |
| `storage.volumeBindingMode` | Volume binding mode for the PVC. Choose from: `Immediate` or `WaitForFirstConsumer` | `Immediate` |
| `storage.allowedTopologies.enabled` | Check [bevel-storageclass](../../../shared/charts/bevel-storageclass/README.md) for details  | `false`  |

### Certs

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `certs.generateCertificates` | Flag to generate certificates for the Peer Node | `true` |
| `certs.orgData.caAddress` | Address of the CA Server without https | `ca.supplychain-net:7051` |
| `certs.orgData.caAdminUser` | CA Admin Username  | `supplychain-admin` |
| `certs.orgData.caAdminPassword` | CA Admin Password  | `supplychain-adminpw` |
| `certs.orgData.orgName` | Organization Name  | `supplychain` |
| `certs.orgData.type` | Type of certificate to generate, choosed from `orderer` or `peer` | `peer` |
| `certs.orgData.componentSubject` | X.509 subject for the organization  | `"O=Peer,L=51.50/-0.13/London,C=GB"` |
| `certs.users.usersList` | Array of Users with their attributes  | `""` |
| `certs.settings.createConfigMaps` | Flag to create configmaps. Must be set to `false` for additional orderers/peers in the same organization. | `false` |
| `certs.settings.refreshCertValue` | Flag to refresh User certificates  | `false` |
| `certs.settings.addPeerValue` | Flag to be used when adding a new peer to the organization  | `false` |
| `certs.settings.removeCertsOnDelete` | Flag to delete the user and peer certificates on uninstall  | `false` |
| `certs.settings.removePeerTlsOnDelete` | Flag to delete the orderer TLS certificates on uninstall | `false` |

### Image

| Name   | Description    | Default Value   |
| -------------| ---------- | --------- |
| `image.couchdb`  | CouchDB image repository | `ghcr.io/hyperledger/bevel-fabric-couchdb` |
| `image.peer`  | Fabric Peer image repository | `ghcr.io/hyperledger/bevel-fabric-peer` |
| `image.alpineUtils`  | Alpine utils image repository and tag | `ghcr.io/hyperledger/bevel-alpine:latest` |
| `image.pullSecret`    | Secret name in the namespace containing private image registry credentials | `""`            |

### Peer

| Name   | Description  | Default Value |
|--------|---------|-------------|
| `peer.gossipPeerAddress` | Internal or External Address of the Gossip Peer Node, leave empty to use Peer's own address | `peer1.supplychain-net:7051` |
| `peer.logLevel` | Log level for the Peer Node | `info` |
| `peer.localMspId` | Local MSP ID for the Peer Organization  | `supplychainMSP` |
| `peer.tlsStatus` | TLS status of the Peer Node  | `true` |
| `peer.cliEnabled` | Flag to deploy the Peer CLI. Check [fabric-cli](../fabric-cli/README.md) for details  | `false` |
| `peer.ordererAddress` | Orderer Internal or External Address with port for CLI to connect  | `orderer1.supplychain-net:7050` |
| `peer.builder` | Chaincode Builder Image repository  | `hyperledger/fabric-ccenv` |
| `peer.couchdb.username` | CouchDB User Name | `supplychain-user` |
| `peer.couchdb.password` | CouchDB User Password | ` supplychain-userpw` |
| `peer.mspConfig.organizationalUnitIdentifiers` | List of Organizational Unit Identifiers for Peer MSP Config | `""` |
| `peer.mspConfig.nodeOUs.clientOUIdentifier` | Organizational Unit Identifier to identify node as client | `client` |
| `peer.mspConfig.nodeOUs.peerOUIdentifier` | Organizational Unit Identifier to identify node as peer | `peer` |
| `peer.mspConfig.nodeOUs.adminOUIdentifier` | Organizational Unit Identifier to identify node as admin | `admin` |
| `peer.mspConfig.nodeOUs.ordererOUIdentifier` | Organizational Unit Identifier to identify node as orderer | `orderer` |
| `peer.serviceType` | Service Type for the GRPC Service  | `ClusterIP` |
| `peer.loadBalancerType` | Load Balancer Type for the GRPC Service  | `""` |
| `peer.ports.grpc.nodePort` | NodePort for the Peer GRPC Service  | `""` |
| `peer.ports.grpc.clusterIpPort` | TCP Port for the Peer GRPC Service  | `7051` |
| `peer.ports.events.nodePort` | NodePort for the Peer Events Service  | `""` |
| `peer.ports.events.clusterIpPort` | TCP Port for the Peer Events Service  | `7053` |
| `peer.ports.couchdb.nodePort` | NodePort for the CouchDB Service  | `""` |
| `peer.ports.couchdb.clusterIpPort` | TCP Port for the CouchDB Service  | `5984` |
| `peer.ports.metrics.enabled` | Flag to enable metrics port  | `false` |
| `peer.ports.metrics.clusterIpPort` | TCP Port for the Peer metrics | `9443` |
| `peer.resources.limits.memory` | Memory limit for the Peer Node  | `1Gi` |
| `peer.resources.limits.cpu` | CPU limit for the Peer Node  | `1` |
| `peer.resources.requests.memory` | Memory request for the Peer Node  | `512M` |
| `peer.resources.requests.cpu` | CPU request for the Peer Node  | `0.25` |
| `peer.upgrade` | Flag to denote that Peer is being upgraded | `false` |
| `peer.healthCheck.retries` | Retry count to connect to Vault  | `20` |
| `peer.healthCheck.sleepTimeAfterError` | Wait seconds after unsuccessful connection attempt  | `15` |

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
