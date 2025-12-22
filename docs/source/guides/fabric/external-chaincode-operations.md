[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)
# External chaincode operations using Bevel

Once a Hyperledger Fabric network is up using Bevel, Bevel users might want to deploy, install, approve, and commit external chaincodes. Bevel supports this task, although there are a few pre-requisites.

 - [Prerequisites](#prerequisites)
 - [External builder and launcher](#external-builder-and-launcher)
 - [Update the configuration file](#update-the-configuration-file)
 - [Execute playbook](#execute-playbook)


## Prerequisites

1. Configure your chaincode to accept env-vars required for the chaincode to run as an external service. For Bevel to be able to execute the external chaincode server, TLS must be enabled and the following env-vars configured in the chaincode:
      - `CHAINCODE_ID`: ID generated after installing the chaincode
      - `CHAINCODE_SERVER_ADDRESS`: Host and port details where the shim server will be listening
      - `CHAINCODE_TLS_DISABLED`: Boolean flag for if TLS is disabled
      - `CHAINCODE_TLS_KEY`: If TLS is enabled, path to the Client key
      - `CHAINCODE_TLS_CERT`: If TLS is enabled, path to the Client certificate
      - `CHAINCODE_CLIENT_CA_CERT`: If TLS is enabled, path to the Root CA cetificate

    A sample chaincode server snippet in GOLANG is below, details can be found [here](https://github.com/hyperledger/fabric-samples/blob/main/asset-transfer-basic/chaincode-external/assetTransfer.go):
    ```go
    ...
    // ===================================================================================
    // Main
    // ===================================================================================
    func main() {
      config := serverConfig{
        CCID:    os.Getenv("CHAINCODE_ID"),
        Address: os.Getenv("CHAINCODE_SERVER_ADDRESS"),
      }

        chaincode, err := contractapi.NewChaincode(&SmartContract{})
      if err != nil {
        log.Panicf("error create asset-transfer-basic chaincode: %s", err)
      }

      server := &shim.ChaincodeServer{
        CCID:     config.CCID,
        Address:  config.Address,
        CC:       chaincode,
        TLSProps: getTLSProperties(),
      }

      if err := server.Start(); err != nil {
        log.Panicf("error starting asset-transfer-basic chaincode: %s", err)
      }
    }
    // TLS Function
    func getTLSProperties() shim.TLSProperties {
      // Check if chaincode is TLS enabled
      tlsDisabledStr := getEnvOrDefault("CHAINCODE_TLS_DISABLED", "true")
      key := getEnvOrDefault("CHAINCODE_TLS_KEY", "")
      cert := getEnvOrDefault("CHAINCODE_TLS_CERT", "")
      clientCACert := getEnvOrDefault("CHAINCODE_CLIENT_CA_CERT", "")

      // convert tlsDisabledStr to boolean
      tlsDisabled := getBoolOrDefault(tlsDisabledStr, false)
      var keyBytes, certBytes, clientCACertBytes []byte
      var err error

      if !tlsDisabled {
        keyBytes, err = os.ReadFile(key)
        if err != nil {
          log.Panicf("error while reading the crypto file: %s", err)
        }
        certBytes, err = os.ReadFile(cert)
        if err != nil {
          log.Panicf("error while reading the crypto file: %s", err)
        }
      }
      // Did not request for the peer cert verification
      if clientCACert != "" {
        clientCACertBytes, err = os.ReadFile(clientCACert)
        if err != nil {
          log.Panicf("error while reading the crypto file: %s", err)
        }
      }

      return shim.TLSProperties{
        Disabled:      tlsDisabled,
        Key:           keyBytes,
        Cert:          certBytes,
        ClientCACerts: clientCACertBytes,
      }
    }
    ...
    ```
1. Package the chaincode as a container/docker image, and then upload to your choice of container registry. For our `asset-transfer` sample, we have used this [code](https://github.com/hyperledger/fabric-samples/tree/main/asset-transfer-basic/chaincode-external) and this [Dockerfile](https://github.com/hyperledger/fabric-samples/blob/main/asset-transfer-basic/chaincode-external/Dockerfile). The docker image is available on our [GitHub Repository](https://github.com/orgs/hyperledger/packages/container/package/bevel-samples-example), if you want to inspect it, you can pull it by using the command below.
    ```bash
    docker pull ghcr.io/hyperledger/bevel-samples-example:1.0
    ``` 

## External builder and launcher
External Builders and Launchers is an advanced feature that typically requires custom packaging of the peer image so that it contains all the tools your builder and launcher require. We have used the `sampleBuilder` for our tests. If you have your own build packs, ensure you store them locally from where the ansible-playbook will be executed and pass that path in the `network.yaml`. Also, ensure that you have the custom `core.yaml` setup when deploying the peers, although the `external-chaincode-ops.yaml` playbook will update the peers if you pass the `peer.configpath` correctly,

Make sure the `chaincode` section of core.yaml consists of the following details:

```yaml
###############################################################################
#
#    Chaincode section
#
###############################################################################
chaincode:
  .
  .
  .
  # List of directories to treat as external builders and launchers for
  # chaincode. The external builder detection processing will iterate over the
  # builders in the order specified below.
  externalBuilders:
    - path: /var/hyperledger/production/buildpacks/sampleBuilder
      name: sampleBuilder
  .
  .
  .
```

Refer [this link](https://github.com/hyperledger/fabric-samples/tree/main/asset-transfer-basic/chaincode-external/sampleBuilder/bin) for sample buildpack and [this guide](https://hyperledger-fabric.readthedocs.io/en/release-2.2/cc_launcher.html) for related documentation.


## Update the configuration file
Refer [this guide](../networkyaml-fabric.md) for details on editing the configuration file. For a sample `network.yaml` for external-chaincode, see [network-fabricv2-external-chaincode.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/samples/network-fabricv2-external-chaincode.yaml).

While modifying the configuration file (`network.yaml`), the following two sections are important:

1. `network.organizations.services.peers[i].configpath`: This is the path from where the new `core.yaml` will be read and the peer will be restarted with this. Keep the externalBuilder.path as provided in default above.

2. `network.organizations.services.peers[i].chaincodes[i]`: This will now have different parameters for external chaincode described as below.
      
    - `name`: Name of the chaincode
    - `version`: version of the chaincode
    - `external_chaincode`: Boolean flag must be true to denote this settings are for external chaincode
    - `tls`: Boolean flag for tls enabled or disabled. 
    - `buildpack_path`: Local path to the supplied buildpack to be copied to the peer node
    - `image`: Docker image path for the external chaincode container as described in prerequisites
    - `arguments`: Init arguments required for initialising the chaincode, this is a must for Bevel.
    - `crypto_mount_path`: If TLS is enabled, path to mount TLS certs and key in the chaincode server pod

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2-external-chaincode.yaml:289:319"
```

## Execute playbook

Then execute the ansible-playbook [external-chaincode-ops.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/external-chaincode-ops.yaml) to update the peers, and then install, approve, commit and invoke external chaincodes.

```
ansible-playbook platforms/hyperledger-fabric/configuration/external-chaincode-ops.yaml --extra-vars "@path-to-network.yaml"
```
