[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

<a name = "deploying-fabric-operations-console"></a>
# Deploying Fabric Operations Console

  - [Prerequisites](#prerequisites)
  - [Modifying Configuration File](#modifying-configuration-file)
  - [Run playbook](#run-playbook)

<a name = "prerequisites"></a>
## Prerequisites
The [Fabric Operations Console](https://github.com/hyperledger-labs/fabric-operations-console) can be deployed along with the Fabric Network. 
You can then manually add peers, orderers, CA to the console by importing appropriate JSON files.
Bevel deploys the console together with the required `fabric-deployer` sidecar so channel and ordering-service workflows can use the backend deployer APIs out of the box.

The Helm Chart for Fabric Operations Console is available [here](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/charts/fabric-operations-console).

If you want to create the JSON files automatically by using our ansible playbook, the CA server endpoint should be accessible publicly and that endpoint details added in `organization.ca_data.url`.

---
**NOTE**: The Fabric Operations Console has only been tested with `operations.tls.enabled = false` for Fabric Peers, Orderers and CAs.

---

<a name = "modifying-configuration-file"></a>
## Modifying Configuration File

A Sample configuration file for deploying Operations Console is available [here](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/configuration/samples/network-fabricv2-raft.yaml). Main change being addition of a new key `organization.fabric_console` which when `enabled` will deploy the operations console for the organization.

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:151:166"
      ..
      ..
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:340:350"
      ..
      ..
```

For generic instructions on the Fabric configuration file, refer [this guide](../networkyaml-fabric.md).

<a name = "run-playbook"></a>
## Run playbook

The [deploy-fabric-console.yaml](https://github.com/hyperledger/bevel/tree/main/platforms/hyperledger-fabric/configuration/deploy-fabric-console.yaml) playbook should be used to automatically generate the JSON files and deploy the console. This can be done using the following command

```
ansible-playbook platforms/hyperledger-fabric/configuration/deploy-fabric-console.yaml --extra-vars "@/path/to/network.yaml"
```

This will deploy the console which will be available over your proxy at **https://<org_name>console.<org_namespace>.<org_external_url_suffix>**

The JSON files will be available in `<project_dir>/build/assets` folder. You can import individual files on respective organization console as well as use bulk import for uploading the zip file `<project_dir>/build/console_assets.zip`

Refer [this guide](https://github.com/hyperledger-labs/fabric-operations-console#readme) for details on operating the Console.
