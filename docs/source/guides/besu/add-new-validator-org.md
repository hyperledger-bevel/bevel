[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "adding-new-validator-org-to-existing-network-in-besu"></a>
# Adding a new validator organization in Besu

  - [Prerequisites](#prerequisites)
  - [Create Configuration File](#create-configuration-file)
  - [Run playbook](#run-playbook)

<a name = "prerequisites"></a>
## Prerequisites
To add a new organization in Besu, an existing besu network should be running, enode information of all existing nodes present in the network should be available, genesis file should be available in base64 encoding and the information of transaction manager nodes and existing validator nodes should be available. The new node account should be unlocked prior adding the new node to the existing besu network. 

---
**NOTE**: Addition of a new organization has been tested on an existing network which is created by Bevel. Networks created using other methods may be suitable but this has not been tested by Bevel team.

---

<a name = "create_config_file"></a>
## Create Configuration File

Refer [this guide](../networkyaml-besu.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `network.organization` details along with the transaction manager node details and existing validator and member node details.

---
**NOTE**: Make sure that the genesis file is provided in base64 encoding. Also, if you are adding node to the same cluster as of another node, make sure that you add the ambassador ports of the existing node present in the cluster to the network.yaml

---
For reference, sample `network-besu-new-validatororg.yaml` file [here](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-besu/configuration/samples/network-besu-new-validatororg.yaml)

```yaml
--8<-- "platforms/hyperledger-besu/configuration/samples/network-besu-new-validatororg.yaml:1:155"
```

Three new sections are added to the network.yaml   

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| tm_nodes | Existing network's transaction manager nodes' public addresses with nodeports.|
| besu_nodes | Existing network's besu nodes' public addresses with rpc ports.|
| genesis | Path to existing network's genesis.json in base64.|


<a name = "run_network"></a>
## Run playbook

The [add-validator.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-besu/configuration/add-validator.yaml) playbook is used to add a new validator organization to the existing network. This can be done using the following command

```
ansible-playbook platforms/hyperledger-besu/configuration/add-validator.yaml --extra-vars "@path-to-network.yaml" --extra-vars "add_new_org='true'"
```

