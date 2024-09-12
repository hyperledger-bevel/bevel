[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Add a new member to an existing organization

This guide explains how to add a new validator node to an existing organization in a Hyperledger Besu network using two methods:

1. Using the `site.yaml` playbook: This playbook involves running an Ansible playbook that automates the process of adding a new org to the network.

1. Using `helm install`: This method involves using the `helm install` commands to directly add a new org to the network.

## Method 1: Using the `site.yaml` playbook

1. **Prerequisites**

    To add a new organization in Besu, an existing besu network should be running, enode information of all existing nodes present in the network should be available, genesis file should be available in base64 encoding and the information of besu nodes should be available. The new node account should be unlocked prior adding the new node to the existing besu network. 

    !!! important

        Addition of a new organization has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.

    !!! note 

        The guide is only for the addition of member organization in existing besu network.

1. **Update network.yaml file**

    Make sure that the genesis file is provided in base64 encoding. Also, if you are adding node to the same cluster as of another node, make sure that you add the ambassador ports of the existing node present in the cluster to the network.yaml

    The `network.yaml` file should contain the specific `network.organization` details along with the enode information, genesis file in base64 encoding and tessera transaction manager details

    !!! note

        Make sure that the genesis flie is provided in base64 encoding. Also, if you are adding node to the same cluster as of another node, make sure that you add the ambassador ports of the existing node present in the cluster to the network.yaml

    For reference, sample `network-besu-new-memberorg.yaml` file [here](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-besu/configuration/samples/network-besu-new-memberorg.yaml)

    ```yaml
    --8<-- "platforms/hyperledger-besu/configuration/samples/network-besu-new-memberorg.yaml:1:152"
    ```

    Three new sections are added to the network.yaml

    | Field       | Description                                              |
    |-------------|----------------------------------------------------------|
    | tm_nodes | Existing network's transaction manager nodes' public addresses with nodeport.|
    | besu_nodes | Existing network's besu nodes' public addresses with rpc port.|
    | genesis | Path to existing network's genesis.json in base64.|


1. **Run playbook**

    The [site.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/shared/configuration/site.yaml) playbook is used to add a new organization to the existing network. This can be done using the following command

    ```
    ansible-playbook platforms/shared/configuration/add-new-organization.yaml --extra-vars "@path-to-network.yaml"
    ```

1. **Verify network deployment**

    For instructions on how to troubleshoot network, read [our troubleshooting guide](../../references/troubleshooting.md)


## Method 2: Using `helm install`

    For instructions on how to troubleshoot network, read [our troubleshooting guide](../../../../platforms/hyperledger-besu/charts/README.md)

1. **Update the txnode-sec.yaml file**

    Following changes are must in the `txnode-sec.yaml` file for a new member to be added to the network:

    - `global.proxy.externalUrlSuffix`
	- `tessera.tessera.peerNodes`

1. **Get the genesis and static nodes from existing member and place in besu-genesis/files**

    ```bash
    kubectl --namespace supplychain-bes get configmap besu-peers -o jsonpath='{.data.static-nodes\.json}' > static-nodes.json
    kubectl --namespace supplychain-bes get configmap besu-genesis  -o jsonpath='{.data.genesis\.json}' > genesis.json
    kubectl --namespace supplychain-bes get configmap besu-bootnodes  -o jsonpath='{.data.bootnodes-json}' > bootnodes.json
    ```

1. **Install the besu genesis chart**

    ```bash
    helm install genesis ./besu-genesis --namespace carrier-bes --values ./values/proxy-and-vault/genesis-sec.yaml
    ```

1. **Install the besu-node chart**

    ```bash
    helm install carrier ./besu-node --namespace carrier-bes --values ./values/proxy-and-vault/txnode-sec.yaml --set global.proxy.p2p=15016 --set node.besu.identity="O=Carrier,OU=Carrier,L=51.50/-0.13/London,C=GB"
    ```