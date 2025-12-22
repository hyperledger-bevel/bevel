[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Add a new channel to an existing network

This guide explains how to add a new channel in a Hyperledger Fabric network using two methods:

1. Using the `add-new-channel.yaml` playbook: This method involves running an Ansible playbook that automates the process of adding a new channel to the network.

2. Using `helm install`: This method involves using the `helm install` commands to directly add a new channel to the network.

## Prerequisites
- A fully configured Fabric network with Orderers, Peers, Peer Organization.
- Corresponding crypto materials present in Hashicorp Vault or Kubernetes secrets.
- Hyperledger Bevel configured.

!!! important

    Do not try to add a new organization as a part of this operation. Use only existing organizations for new channel creation. 

## Method 1: Using the `add-new-channel.yaml` playbook

1. **Add a defined channel with genesis or channeltx generated in basic deployment**

    **Update Configuration File**

       - Edit the `network.yaml` file to include a channel with the following details:
           - Organization details (name, CA address, MSP ID, etc.)
   	   - Orderer information
       - Refer to the [networkyaml-fabric.md](../networkyaml-fabric.md) guide for details on editing the configuration file.

       Snippet from `network.channels` section below:

       ```yaml
       --8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:63:165"
       ```

    **Run Playbook**

       Execute the following command to run the `add-new-channel.yaml` playbook:

       ```
       ansible-playbook platforms/hyperledger-fabric/configuration/add-new-channel.yaml --extra-vars "@path-to-network.yaml"
       ```
       Replace `path-to-network.yaml` with the actual path to your updated `network.yaml` file.

   	This will add a channel to the existing Fabric network.

2. **Add a new channel by generating a new genesis or channeltx in an existing network**
 
    **Update Configuration File**

       - Edit the `network.yaml` file to include a new channel with the following details:
           - `channel_status: new`
           - Organization details (name, CA address, MSP ID, etc.)
   		- Orderer information
       - Remove existing channels or use `channel_status: existing`
       - Refer to the [networkyaml-fabric.md](../networkyaml-fabric.md) guide for details on editing the configuration file.

       Snippet from `network.channels` section below:

       ```yaml
       --8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabric-add-new-channel.yaml:63:227"
       ```

    !!! tip

        For reference, see sample [network-fabric-add-channel.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/samples/network-fabric-add-new-channel.yaml) file.

    **Run Playbook**

       Execute the following command to run the `add-new-channel.yaml` playbook:

       ```
       ansible-playbook platforms/hyperledger-fabric/configuration/add-new-channel.yaml --extra-vars "@path-to-network.yaml" -e generate_configtx=true
       ```
       Replace `path-to-network.yaml` with the actual path to your updated `network.yaml` file.

   	This will add a new channel to the existing Fabric network.

## Method 2: Using `helm install`

1. **Update the fabric-genesis values.yaml file**

    Following changes are must in the `values.yaml` file for a new channel to be added to the network:

    - `settings.generateGenesis: false` only needed for Fabric 2.2.x to not generate the syschannel genesis block.
    - `channels` to include the new channel.
	- All other fields as required by your new channel.
    Refer to the [fabric-genesis chart documentation](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/charts/fabric-genesis) for a complete list of available configuration options.

1. **Generate the new channel artifacts**

    First, save the admin MSP and TLS files for the new participants (peers and/or orderers) locally.
    ```bash
        # Obtain certificates and the configuration file of each peer organization, place in fabric-genesis/files
        cd ./platforms/hyperledger-fabric/charts/fabric-genesis/files
        kubectl --namespace org1-net get secret admin-msp -o json > org2.json
        kubectl --namespace org1-net get configmap peer0-msp-config -o json > org1-config-file.json

        #If additional orderer from a different organization is needed in genesis
        kubectl --namespace orderer-net get secret orderer4-tls -o json > orderer4-orderer-tls.json
    ```

    Execute the following command to install the Genesis chart to generate the channel artifacts:
	```bash
    cd ../..
	helm dependency update ./fabric-genesis
	helm install <release-name> ./fabric-genesis --namespace <namespace> --values <values-file.yaml>
	```
	Replace the following placeholders:

	- `<release-name>`: The desired name for the channel artifacts release.
	- `<namespace>`: The Kubernetes namespace where the orderer admins are already present.
	- `<values-file.yaml>`: The path to a YAML file containing the new channel configuration values from Step 1.

1. **Create channel for Hyperledger Fabric 2.5.x**

    Execute the following command to create the channel for Hyperledger Fabric 2.5.x:
    ```bash
    # Create channel
    helm install <new-channel-name> ./fabric-osnadmin-channel-create --namespace <namespace> --values <values-file.yaml>
    ```
    Replace the following placeholders:

	- `<new-channel-name>`: Release name must be the new channel name.
	- `<namespace>`: The Kubernetes namespace where `fabric-genesis` was installed.
	- `<values-file.yaml>`: The path to a YAML file containing the new channel configuration values.
    Refer to the [fabric-osnadmin-channel-create chart documentation](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/charts/fabric-osnadmin-channel-create) for a complete list of available configuration options.

    Execute the following command for each Peer which is to join the new Channel:
    ```bash
    helm install <release-name> ./fabric-channel-join --namespace <namespace> --values <values-file.yaml>
    ```
    Replace the following placeholders:

	- `<release-name>`: The desired name for the join-channel release.
	- `<namespace>`: The Kubernetes namespace where corresponding peer exists.
	- `<values-file.yaml>`: The path to a YAML file containing the join-channel configuration values.
    Refer to the [fabric-channel-join chart documentation](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/charts/fabric-channel-join) for a complete list of available configuration options.

1. **Create channel for Hyperledger Fabric 2.2.x**

    Execute the following command to create the channel for Hyperledger Fabric 2.2.x:
    ```bash
    # Obtain the file channel.tx and place it in fabric-channel-create/files
    cd ./fabric-channel-create/files
    kubectl --namespace <genesis-namespace> get configmap <new-channel-name>-channeltx -o jsonpath='{.data.<new-channel-name>-channeltx_base64}' > channeltx.json

    # Create channel
    cd ../..
    helm install <new-channel-name> ./fabric-channel-create --namespace <namespace> --values <values-file.yaml>
    ```
    Replace the following placeholders:

	- `<new-channel-name>`: Release name must be the new channel name.
	- `<genesis-namespace>`: The Kubernetes namespace where `fabric-genesis` was installed.
    - `<namespace>`: The Kubernetes namespace of the organization creating the new channel.
	- `<values-file.yaml>`: The path to a YAML file containing the new channel configuration values.
    Refer to the [fabric-channel-create chart documentation](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/charts/fabric-channel-create) for a complete list of available configuration options.


    Execute the following command for each Peer which is to join the new Channel:
    ```bash
    cd ./fabric-channel-join/files
    kubectl --namespace <genesis-namespace> get configmap <new-channel-name>-<participant-name>-anchortx -o jsonpath='{.data.<new-channel-name>-<participant-name>-anchortx_base64}' > anchortx.json

    # Join channel
    cd ../..
    helm install <release-name> ./fabric-channel-join --namespace <namespace> --values <values-file.yaml>
    ```
    Replace the following placeholders:

    - `<new-channel-name>`: Release name must be the new channel name.
	- `<genesis-namespace>`: The Kubernetes namespace where `fabric-genesis` was installed.
    - `<participant-name>`: The participating organization name.
	- `<release-name>`: The desired name for the join-channel release.
	- `<namespace>`: The Kubernetes namespace where corresponding peer exists.
	- `<values-file.yaml>`: The path to a YAML file containing the join-channel configuration values.
    Refer to the [fabric-channel-join chart documentation](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/charts/fabric-channel-join) for a complete list of available configuration options.
