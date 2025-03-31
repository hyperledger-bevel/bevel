[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Charts for Substrate components

## About
This folder contains the helm charts which are used for the deployment of the Hyperledger Substrate components. Each helm that you can use has the following keys and you need to set them. The `global.cluster.provider` is used as a key for the various cloud features enabled. Also you only need to specify one cloud provider, **not** both if deploying to cloud. As of writing this doc, AWS and Azure both are fully supported.

```yaml
global:
  serviceAccountName: vault-auth
  cluster:
    provider: aws   # choose from: minikube | aws | azure
    cloudNativeServices: false  # future: set to true to use Cloud Native Services 
    kubernetesUrl: "https://yourkubernetes.com" # Provide the k8s URL, ignore if not using Hashicorp Vault
  vault:
    type: hashicorp # choose from hashicorp | kubernetes
    network: substrate   # must be substrate for these charts
    # Following are necesupplychain-subsary only when hashicorp vault is used.
    addresupplychain-subs: http://vault.url:8200
    authPath: supplychain
    secretEngine: secretsv2
    secretPrefix: "data/supplychain"
    role: vault-role
```

## Usage

### Pre-requisites

- **Kubernetes Cluster:** Ensure you have a running Kubernetes cluster (either Managed cloud option like AKS or local like minikube).
- **Hashicorp Vault:** Accessible and unsealed Hahsicorp Vault (if using Vault).
- **Ambassador Edge stack**: Configured Ambassador AES (if using Ambassador as proxy)
- **Helm:** Install Helm CLI on your local machine.
- **kubectl:** Install kubectl CLI and configure access to your Kubernetes 

---

## `Without Proxy and Vault`

## `Step 1: Setup Namespaces`

Ccreate the required namespaces:

```bash
kubectl create ns oem-subs
kubectl create ns tierone-subs
kubectl create ns tiertwo-subs
```

## `Step 2: Navigate to the Target Directory`

Change to the appropriate directory where the Substrate charts are located:

```bash
cd platforms/substrate/charts
```

## `Step 3: Deploy Key Generators`

Update Helm dependencies and install key generator charts:

### OEM Namespace

```bash
# Update Helm dependencies for the key generator chart
helm dep update substrate-key-gen

# Generate keys for the 1st validator node
helm install oem-validator-1 substrate-key-gen -n oem1-subs -f values/noproxy-and-novault/key-gen.yaml --set node.isValidator=true,tags.bevel-vault-mgmt=true,tags.bevel-scripts=true

# Generate keys for the 2nd validator node
helm install oem-validator-2 substrate-key-gen -n oem1-subs -f values/noproxy-and-novault/key-gen.yaml --set node.isValidator=true

# Generate keys for the 1st member node
helm install oem-member-1 substrate-key-gen -n oem1-subs -f values/noproxy-and-novault/key-gen.yaml --set node.isMember=true

```

### TierOne Namespace

```bash
# Generate keys for the 3rd validator node
helm install tierone-validator-3 substrate-key-gen -n tierone1-subs -f values/noproxy-and-novault/key-gen.yaml --set node.isValidator=true,tags.bevel-vault-mgmt=true,tags.bevel-scripts=true

# Generate keys for the 4th validator node
helm install tierone-validator-4 substrate-key-gen -n tierone1-subs -f values/noproxy-and-novault/key-gen.yaml --set node.isValidator=true

# Generate keys for the 2nd member node
helm install tierone-member-2 substrate-key-gen -n tierone1-subs -f values/noproxy-and-novault/key-gen.yaml --set node.isMember=true
```

### TierTwo Namespace

```bash
# Generate keys for the 3rd member node
helm install tiertwo-member-3 substrate-key-gen -n tiertwo1-subs -f values/noproxy-and-novault/key-gen.yaml --set node.isMember=true,tags.bevel-vault-mgmt=true,tags.bevel-scripts=true
```

## `Step 4: Deploy Genesis`

Apply the global service account and deploy the genesis chart:

```bash
# Apply the global service account
kubectl apply -f build/global-sa.yaml -n oem-subs

# Deploy the genesis chart
helm install oem-genesis substrate-genesis -n oem1-subs -f values/noproxy-and-novault/genesis.yaml
```

## `Step 5: Deploy Nodes`

Update Helm dependencies and deploy the nodes:

### OEM Nodes

```bash
# Update Helm dependencies for the substrate-node chart
helm dep update substrate-node

# Start the validator node 1 also known as Bootnode
helm install oem-validator-1-node ./substrate-node --namespace oem1-subs --values ./values/noproxy-and-novault/node.yaml --set node.isBootnode.enabled=false,node_keys_k8s=oem-validator-1-keys

# Extract the Bootnode Id required by others to join the network.
BOOTNODE_ID=$(kubectl get secret "oem-validator-1-keys" --namespace oem1-subs -o json | jq -r '.data["substrate-node-keys"]' | base64 -d | jq -r '.data.node_id')

# Start the validator node 2
helm install oem-validator-2-node ./substrate-node --namespace oem1-subs --values ./values/noproxy-and-novault/node.yaml --set node_keys_k8s=oem-validator-2-keys,node.isBootnode.boot_node_id=${BOOTNODE_ID}

# Start the member node 1
helm install oem-member-1-node ./substrate-node --namespace oem1-subs --values ./values/noproxy-and-novault/node.yaml --set node.role=full,node_keys_k8s=oem-member-1-keys,node.isBootnode.boot_node_id=${BOOTNODE_ID}
```

### TierOne Nodes

```bash
# Start the validator node 3
helm install tierone-validator-3-node ./substrate-node --namespace tierone1-subs --values ./values/noproxy-and-novault/node.yaml --set node_keys_k8s=tierone-validator-3-keys,node.isBootnode.boot_node_id=${BOOTNODE_ID}

# Start the validator node 4
helm install tierone-validator-4-node ./substrate-node --namespace tierone1-subs --values ./values/noproxy-and-novault/node.yaml --set node_keys_k8s=tierone-validator-4-keys,node.isBootnode.boot_node_id=${BOOTNODE_ID}

# Start the member node 2
helm install tierone-member-2-node ./substrate-node --namespace tierone1-subs --values ./values/noproxy-and-novault/node.yaml --set node.role=full,node_keys_k8s=tierone-member-2-keys,node.isBootnode.boot_node_id=${BOOTNODE_ID}
```

### TierTwo Nodes

```bash
# Start the member node 3
helm install tiertwo-member-3-node ./substrate-node --namespace tiertwo1-subs --values ./values/noproxy-and-novault/node.yaml --set node.role=full,node_keys_k8s=tiertwo-member-3-keys,node.isBootnode.boot_node_id=${BOOTNODE_ID}
```

## `Step 6: Install IPFS Nodes`

Install and configure IPFS nodes for each namespace.

### OEM IPFS Node

```bash
# Update Helm dependencies for the dscp-ipfs-node chart
helm dependency update ./dscp-ipfs-node

# IPFS Node 1
helm install dscp-ipfs-node-1 ./dscp-ipfs-node --namespace oem1-subs --values ./values/noproxy-and-novault/ipfs.yaml \
--set config.nodeHost="oem-member-1-node-substrate-node-0"

peer_id=$(kubectl logs dscp-ipfs-node-1-0 -n oem1-subs -c ipfs-init | grep "peer_id" | awk -F ': ' '{print $2}')

# IPFS Node 2
helm install dscp-ipfs-node-2 ./dscp-ipfs-node --namespace oem1-subs --values ./values/noproxy-and-novault/ipfs.yaml \
--set config.nodeHost="oem-member-1-node-substrate-node-0",config.ipfsBootNodeAddress="/dns4/dscp-ipfs-node-1-swarm.oem1-subs/tcp/4001/p2p/${peer_id}"
```

### TierOne IPFS Node

```bash
# IPFS Node 3
helm install dscp-ipfs-node-3 ./dscp-ipfs-node --namespace tierone1-subs --values ./values/noproxy-and-novault/ipfs.yaml \
--set config.nodeHost="tierone-member-2-node-substrate-node-0",config.ipfsBootNodeAddress="/dns4/dscp-ipfs-node-1-swarm.oem1-subs/tcp/4001/p2p/${peer_id}"
```

### TierTwo IPFS Node

```bash
# IPFS Node 4
helm install dscp-ipfs-node-4 ./dscp-ipfs-node --namespace tiertwo1-subs --values ./values/noproxy-and-novault/ipfs.yaml \
--set config.nodeHost="tiertwo-member-3-node-substrate-node-0",config.ipfsBootNodeAddress="/dns4/dscp-ipfs-node-1-swarm.oem1-subs/tcp/4001/p2p/${peer_id}"
```

## `With Proxy and Vault`

## `Step 1: Setup Namespaces`

Ccreate the required namespaces:

```bash
kubectl create ns oem-subs
kubectl create ns tierone-subs
kubectl create ns tiertwo-subs
```

## `Step 2: Create Secrets`

Create the `roottoken` secret in each namespace:

```bash
kubectl -n oem-subs create secret generic roottoken --from-literal=token=<vault_root_token>

kubectl -n tierone-subs create secret generic roottoken --from-literal=token=<vault_root_token>

kubectl -n tiertwo-subs create secret generic roottoken --from-literal=token=<vault_root_token>
```

## `Step 3: Navigate to the Target Directory`

Change to the appropriate directory where the Substrate charts are located:

```bash
cd platforms/substrate/charts
```

## `Step 4: Deploy Key Generators`

Update Helm dependencies and install key generator charts:

### OEM Namespace

```bash
# Update Helm dependencies for the key generator chart
helm dep update substrate-key-gen

# Generate keys for the 1st validator node
helm install oem-validator-1 substrate-key-gen -n oem-subs -f values/proxy-and-vault/key-gen.yaml --set node.isValidator=true,tags.bevel-vault-mgmt=true,tags.bevel-scripts=true

# Generate keys for the 2nd validator node
helm install oem-validator-2 substrate-key-gen -n oem-subs -f values/proxy-and-vault/key-gen.yaml --set node.isValidator=true

# Generate keys for the 1st member node
helm install oem-member-1 substrate-key-gen -n oem-subs -f values/proxy-and-vault/key-gen.yaml --set node.isMember=true

```

### Tier-One Namespace

```bash
# Generate keys for the 3rd validator node
helm install tierone-validator-3 substrate-key-gen -n tierone-subs -f values/proxy-and-vault/key-gen.yaml --set node.isValidator=true,tags.bevel-vault-mgmt=true,tags.bevel-scripts=true,global.vault.authPath="tierone",global.vault.secretPrefix="data/tierone"

# Generate keys for the 4th validator node
helm install tierone-validator-4 substrate-key-gen -n tierone-subs -f values/proxy-and-vault/key-gen.yaml --set node.isValidator=true,global.vault.authPath="tierone",global.vault.secretPrefix="data/tierone"

# Generate keys for the 2nd member node
helm install tierone-member-2 substrate-key-gen -n tierone-subs -f values/proxy-and-vault/key-gen.yaml --set node.isMember=true,global.vault.authPath="tierone",global.vault.secretPrefix="data/tierone"
```

### Tier-Two Namespace

```bash
# Generate keys for the 3rd member node
helm install tiertwo-member-3 substrate-key-gen -n tiertwo-subs -f values/proxy-and-vault/key-gen.yaml --set node.isMember=true,tags.bevel-vault-mgmt=true,tags.bevel-scripts=true,global.vault.authPath="tiertwo",global.vault.secretPrefix="data/tiertwo"
```

## `Step 5: Deploy Genesis`

Apply the global service account and deploy the genesis chart:

```bash
# Apply the global service account
kubectl apply -f build/global-sa.yaml -n oem-subs

# Deploy the genesis chart
helm install oem-genesis substrate-genesis -n oem-subs -f values/proxy-and-vault/genesis.yaml
```

## `Step 6: Deploy Nodes`

Update Helm dependencies and deploy the nodes:

### OEM Nodes

```bash
# Update Helm dependencies for the substrate-node chart
helm dep update substrate-node

# Start the validator node 1 also known as Bootnode
helm install oem-validator-1-node ./substrate-node --namespace oem-subs --values ./values/proxy-and-vault/node.yaml --set proxy.p2p=15011,node.isBootnode.enabled=false,node_keys_k8s=oem-validator-1-keys

# Extract the Bootnode Id required by others to join the network.
BOOTNODE_ID=$(kubectl get secret "oem-validator-1-keys" --namespace oem-subs -o json | jq -r '.data["substrate-node-keys"]' | base64 -d | jq -r '.data.node_id')

# Start the validator node 2
helm install oem-validator-2-node ./substrate-node --namespace oem-subs --values ./values/proxy-and-vault/node.yaml --set proxy.p2p=15012,node_keys_k8s=oem-validator-2-keys,node.isBootnode.boot_node_id=${BOOTNODE_ID}

# Start the member node 1
helm install oem-member-1-node ./substrate-node --namespace oem-subs --values ./values/proxy-and-vault/node.yaml --set proxy.p2p=15013,node.role=full,node_keys_k8s=oem-member-1-keys,node.isBootnode.boot_node_id=${BOOTNODE_ID}
```

### TierOne Nodes

```bash
# Start the validator node 3
helm install tierone-validator-3-node ./substrate-node --namespace tierone-subs --values ./values/proxy-and-vault/node.yaml --set proxy.p2p=15014,node_keys_k8s=tierone-validator-3-keys,node.isBootnode.boot_node_id=${BOOTNODE_ID}

# Start the validator node 4
helm install tierone-validator-4-node ./substrate-node --namespace tierone-subs --values ./values/proxy-and-vault/node.yaml --set proxy.p2p=15015,node_keys_k8s=tierone-validator-4-keys,node.isBootnode.boot_node_id=${BOOTNODE_ID}

# Start the member node 2
helm install tierone-member-2-node ./substrate-node --namespace tierone-subs --values ./values/proxy-and-vault/node.yaml --set proxy.p2p=15016,node.role=full,node_keys_k8s=tierone-member-2-keys,node.isBootnode.boot_node_id=${BOOTNODE_ID}
```

### TierTwo Nodes

```bash
# Start the member node 3
helm install tiertwo-member-3-node ./substrate-node --namespace tiertwo-subs --values ./values/proxy-and-vault/node.yaml --set proxy.p2p=15017,node.role=full,node_keys_k8s=tiertwo-member-3-keys,node.isBootnode.boot_node_id=${BOOTNODE_ID}
```

## `Step 7: Install IPFS Nodes`

Install and configure IPFS nodes for each namespace.

### OEM IPFS Node

```bash
# Update Helm dependencies for the dscp-ipfs-node chart
helm dependency update ./dscp-ipfs-node

# IPFS Node 1
helm install dscp-ipfs-node-1 ./dscp-ipfs-node --namespace oem-subs --values ./values/proxy-and-vault/ipfs.yaml \
--set config.nodeHost="oem-member-1-node-substrate-node-0",proxy.port=15018,global.vault.authPath="oem",global.vault.secretPrefix="data/oem"

peer_id=$(kubectl logs dscp-ipfs-node-1-0 -n oem-subs -c ipfs-init | grep "peer_id" | awk -F ': ' '{print $2}')

# IPFS Node 2
helm install dscp-ipfs-node-2 ./dscp-ipfs-node --namespace oem-subs --values ./values/proxy-and-vault/ipfs.yaml \
--set config.nodeHost="oem-member-1-node-substrate-node-0",config.ipfsBootNodeAddress="/dns4/dscp-ipfs-node-1-swarm.oem-subs/tcp/4001/p2p/${peer_id}",proxy.port=15019,global.vault.authPath="oem",global.vault.secretPrefix="data/oem"
echo "" && echo ""
```

### TierOne IPFS Node

```bash
# IPFS Node 3

helm install dscp-ipfs-node-3 ./dscp-ipfs-node --namespace tierone-subs --values ./values/proxy-and-vault/ipfs.yaml \
--set config.nodeHost="tierone-member-2-node-substrate-node-0",config.ipfsBootNodeAddress="/dns4/dscp-ipfs-node-1-swarm.oem-subs/tcp/4001/p2p/${peer_id}",proxy.port=15020,global.vault.authPath="tierone",global.vault.secretPrefix="data/tierone"
```

### TierTwo IPFS Node

```bash
# IPFS Node 4

helm install dscp-ipfs-node-4 ./dscp-ipfs-node --namespace tiertwo-subs --values ./values/proxy-and-vault/ipfs.yaml \
--set config.nodeHost="tiertwo-member-3-node-substrate-node-0",config.ipfsBootNodeAddress="/dns4/dscp-ipfs-node-1-swarm.oem-subs/tcp/4001/p2p/${peer_id}",proxy.port=15021,global.vault.authPath="tiertwo",global.vault.secretPrefix="data/tiertwo"
```

## `Clenup`

To clean up, simply uninstall the Helm releases. It's important to uninstall the genesis Helm chart at the end to prevent any cleanup failure.
```bash
helm uninstall oem-genesis           --namespace oem-subs
helm uninstall oem-validator-1       --namespace oem-subs
helm uninstall oem-validator-2       --namespace oem-subs
helm uninstall oem-member-1          --namespace oem-subs
helm uninstall oem-validator-1-node  --namespace oem-subs
helm uninstall oem-validator-2-node  --namespace oem-subs
helm uninstall oem-member-1-node     --namespace oem-subs
helm uninstall dscp-ipfs-node-1      --namespace oem-subs
helm uninstall dscp-ipfs-node-2      --namespace oem-subs

helm uninstall tierone-validator-3       --namespace tierone-subs
helm uninstall tierone-validator-4       --namespace tierone-subs
helm uninstall tierone-member-2          --namespace tierone-subs
helm uninstall tierone-validator-3-node  --namespace tierone-subs
helm uninstall tierone-validator-4-node  --namespace tierone-subs
helm uninstall tierone-member-2-node     --namespace tierone-subs
helm uninstall dscp-ipfs-node-3          --namespace tierone-subs

helm uninstall tiertwo-member-3       --namespace tiertwo-subs
helm uninstall tiertwo-member-3-node  --namespace tiertwo-subs
helm uninstall dscp-ipfs-node-4       --namespace tiertwo-subs

kubectl delete ns oem-subs
kubectl delete ns tierone-subs
kubectl delete ns tiertwo-subs
```
