[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "upgrading-chaincode"></a>
# Upgrading chaincode in Hyperledger Fabric

- [Pre-requisites](#pre-requisites)
- [Modifying configuration file](#modifying-configuration-file)
- [Run playbook for Fabric version 1.4.x](#run-playbook-for-fabric-version-14x)
- [Run playbook for Fabric version 2.2.x](#run-playbook-for-fabric-version-22x)
- [Run playbook for Fabric version 2.2.x with external chaincode](#run-playbook-for-fabric-version-22x-with-external-chaincode)

<a name = "pre_req"></a>
## Pre-requisites
Hyperledger Fabric network deployed, network.yaml configuration file already set and chaincode is installed and instantiated or packaged, approved and committed in case of Fabric version 2.2.

<a name = "create_config_file"></a>
## Modifying configuration file

Refer [this guide](../networkyaml-fabric.md) for details on editing the configuration file.

The `network.yaml` file should contain the specific `network.organizations.services.peers.chaincodes[*].arguments`, `network.organizations.services.peers.chaincodes[*].version` and `network.organizations.services.peers.chaincodes[*].name` variables which are used as arguments while upgrading the chaincode.

For reference, following snippet shows that section of `network.yaml`

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:242:248"
      ..
      ..
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:297:297"
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:304:338"
```

When the chaincode is an external service, `network.organizations.services.peers.chaincodes[*].upgrade_chaincode` variable must also be added to change the version. If only the sequence is modified, it isn't necessary to add this field.

The sequence must be incremented in each execution regardless of whether the version has been modified or not.

For reference, following snippet shows that section of `network.yaml`

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2-external-chaincode.yaml:227:233"
      ..
      ..
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2-external-chaincode.yaml:282:282"
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2-external-chaincode.yaml:289:321"
```

<a name = "run_network"></a>
## Run playbook for Fabric version 1.4.x

The playbook [chaincode-upgrade.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/chaincode-upgrade.yaml) is used to upgrade chaincode to a new version in the existing fabric network with version 1.4.x.
This can be done by using the following command

```
    ansible-playbook platforms/hyperledger-fabric/configuration/chaincode-upgrade.yaml --extra-vars "@path-to-network.yaml"
```

## Run playbook for Fabric version 2.2.x

The playbook [chaincode-ops.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/chaincode-ops.yaml) is used to upgrade chaincode to a new version in the existing fabric network with version 2.2.x.
This can be done by using the following command

```
    ansible-playbook platforms/hyperledger-fabric/configuration/chaincode-ops.yaml --extra-vars "@path-to-network.yaml"
```
## Run playbook for Fabric version 2.2.x with external chaincode

The playbook [external-chaincode-ops.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/external-chaincode-ops.yaml) is used to upgrade chaincode to a new version in the existing fabric network with version 2.2.x.
This can be done by using the following command

```
    ansible-playbook platforms/hyperledger-fabric/configuration/external-chaincode-ops.yaml --extra-vars "@path-to-network.yaml"
```

---
**NOTE:** The Chaincode should be upgraded for all participants of the channel.