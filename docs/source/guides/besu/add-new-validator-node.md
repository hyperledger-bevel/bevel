[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Add a new validator node to an existing organization

This guide explains how to add a new validator node to an existing organization in a Hyperledger Besu network using two methods:

1. Using the `add-validator.yaml` playbook: This method involves running an Ansible playbook that automates the process of adding a new node to the network.

1. Using `helm install`: This method involves using the `helm install` commands to directly add a new node to the network.

## Method 1: Using the `add-validator.yaml` playbook

1. **Prerequisites**

    To add a new node in Besu, an existing besu network should be running, enode information of all existing nodes present in the network should be available, genesis file should be available in base64 encoding and the information of transaction manager nodes and existing validator nodes should be available. The new node account should be unlocked prior adding the new node to the existing besu network. 

The `network.yaml` file should contain the specific `network.organization` details along with the tessera transaction manager node details and existing validator and member node details.

---
**NOTE**: Make sure that the genesis file is provided in base64 encoding. Also, if you are adding node to the same cluster as of another node, make sure that you add the ambassador ports of the existing node present in the cluster to the network.yaml

---
For reference, sample `network-besu-new-validatornode.yaml` file [here](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-besu/configuration/samples/network-besu-new-validatornode.yaml)

```yaml
--8<-- "platforms/hyperledger-besu/configuration/samples/network-besu-new-validatornode.yaml:1:201"
```

Three new sections are added to the network.yaml   

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| tm_nodes | Existing network's transaction manager nodes' public addresses with nodeport.|
| besu_nodes | Existing network's besu nodes' public addresses with rpc port.|
| genesis | Path to existing network's genesis.json in base64.|


1. **Update configuration file**

    Refer [this guide](../networkyaml-besu.md) for details on editing the configuration file.

    The `network.yaml` file should contain the specific `network.organization` details along with the tessera transaction manager node details and existing validator and member node details.

    ---
    **NOTE**: Make sure that the genesis flie is provided in base64 encoding. Also, if you are adding node to the same cluster as of another node, make sure that you add the ambassador ports of the existing node present in the cluster to the network.yaml

    ---
    For reference, sample `network-besu-new-validatornode.yaml` file [here](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-besu/configuration/samples/network-besu-new-validatornode.yaml)

    ```yaml
    --8<-- "platforms/hyperledger-besu/configuration/samples/network-besu-new-validatornode.yaml:1:201"
    ```

    Three new sections are added to the network.yaml   

    | Field       | Description                                              |
    |-------------|----------------------------------------------------------|
    | tm_nodes | Existing network's transaction manager nodes' public addresses with nodeport.|
    | besu_nodes | Existing network's besu nodes' public addresses with rpc port.|
    | genesis | Path to existing network's genesis.json in base64.|


1. **Run playbook**

    The [add-validator.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-besu/configuration/add-validator.yaml) playbook is used to add a new validator node to an existing organization in a running network. This can be done using the following command

    ```
    ansible-playbook platforms/hyperledger-besu/configuration/add-validator.yaml --extra-vars "@path-to-network.yaml"
    ```

## Method 2: Using `helm install`

1. **Update the besu-node values.yaml and besu-propose-validator values.yaml file**

    Refer to the [besu-propose-validator chart documentation](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-besu/charts/besu-propose-validator) for a complete list of available configuration options.

1. **Install the besu-propose-validator chart**

    ```bash
    helm install validator-5 ./besu-propose-validator --namespace supplychain-bes --values besu-propose-validator/values.yaml
    ```