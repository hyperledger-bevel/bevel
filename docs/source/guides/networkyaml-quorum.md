[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Configuration file specification: Quorum
A network.yaml file is the base configuration file designed in Hyperledger Bevel for setting up a Quorum DLT network. This file contains all the configurations related to the network that has to be deployed. Below shows its structure.
![](./../_static/TopLevelClass-Quorum.png)

Before setting up a Quorum DLT/Blockchain network, this file needs to be updated with the required specifications.  

A sample configuration file is provided in the repo path:  
`platforms/quorum/configuration/samples/network-quorum.yaml` 

A json-schema definition is provided in `platforms/network-schema.json` to assist with semantic validations and lints. You can use your favorite yaml lint plugin compatible with json-schema specification, like `redhat.vscode-yaml` for VSCode. You need to adjust the directive in template located in the first line based on your actual build directory:

`# yaml-language-server: $schema=../platforms/network-schema.json`

The configurations are grouped in the following sections for better understanding.

* [type](#type)

* [version](#version)

* [env](#env)

* [docker](#docker)

* [config](#config)

* [organizations](#organizations)

Although, the file itself has comments for each key-value, here is a more detailed description with respective snippets.
=== "Quorum"
    Use this [sample configuration file](https://github.com/hyperledger/bevel/blob/main/platforms/quorum/configuration/samples/network-quorum.yaml) as a base.
    ```yaml
    --8<-- "platforms/quorum/configuration/samples/network-quorum.yaml:7:15"
    ```

The sections in the sample configuration file are  

<a name="type"></a>
type
: `type` defines the platform choice like corda/fabric/indy/quorum, here in the example it's **quorum**.

<a name="version"></a>
version
: `version` defines the version of platform being used. The current Quorum version support is only for **21.4.2**

!!! important

    Use Quorum Version 23.4.0 if you are deploying Supplychain smartcontracts from examples.

<a name="env"></a>
env
: `env` section contains the environment type and additional (other than 443) Ambassador port configuration. Value for proxy field under this section can be 'ambassador' or 'haproxy'

The snippet of the `env` section with example value is below

```yaml
--8<-- "platforms/quorum/configuration/samples/network-quorum.yaml:18:31"
```

The fields under `env` section are 

| Field      | Description                                 |
|------------|---------------------------------------------|
| type       | Environment type. Can be like dev/test/prod.|
| proxy      | Choice of the Cluster Ingress controller. Currently supports 'ambassador' only as 'haproxy' has not been implemented for Quorum |
| ambassadorPorts   | Any additional Ambassador ports can be given here. This is only valid if `proxy: ambassador`. These ports are enabled per cluster, so if you have multiple clusters you do not need so many ports to be opened on Ambassador. Our sample uses a single cluster, so we have to open 4 ports for each Node. These ports are again specified in the `organization` section.     |
| loadBalancerSourceRanges | Restrict inbound access to a single or list of IP addresses for the public Ambassador ports to enhance Bevel network security. This is only valid if `proxy: ambassador`.  |
| retry_count       | Retry count for the checks. Use a high number if your cluster is slow. |
|external_dns       | If the cluster has the external DNS service, this has to be set `enabled` so that the hosted zone is automatically updated. |

<a name="docker"></a>
docker
: `docker` section contains the credentials of the repository where all the required images are built and stored.

The snippet of the `docker` section with example values is below
```yaml
--8<-- "platforms/quorum/configuration/samples/network-quorum.yaml:33:39"
```

The fields under `docker` section are

| Field    | Description                            |
|----------|----------------------------------------|
| url      | Docker registry url                    |
| username | Username required for login to docker registry|
| password | Password required for login to docker registry|


<a name="config"></a>
config
: `config` section contains the common configurations for the Quorum network.

The snippet of the `config` section with example values is below
```yaml
--8<-- "platforms/quorum/configuration/samples/network-quorum.yaml:42:63"
```

The fields under `config` are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| consensus   | Currently supports `raft` or `ibft`. Please update the remaining items according to the consensus chosen as not all values are valid for both the consensus.                                 |
| subject     | This is the subject of the root CA which will be created for the Quorum network. The root CA is for development purposes only, production networks should already have the root certificates.   |
| transaction_manager    | Options are `tessera` and `none`. Please update the remaining items according to the transaction_manager chosen as not all values are valid for both the transaction_manager. |
| tm_version         | This is the version of `tessera` that will be deployed. Supported versions: `23.4.0` for `tessera`. |
| tm_tls | Options are `strict` and `off`. This enables TLS for the transaction managers, and is not related to the actual Quorum network. `off` is not recommended for production. |
| tm_trust | Options are: `ca-or-tofu`, `ca`, `tofu`. This is the trust relationships for the transaction managers. More details [for tessera]( https://github.com/jpmorganchase/tessera/wiki/TLS).|
| tm_nodes | The Transaction Manager nodes public addresses should be provided. For `tessera`, all participating nodes should be provided. |
| staticnodes | This is the path where staticnodes will be stored for a new network; for adding new node, the existing network's staticnodes should be available in yaml format in this file.|
| genesis | This is the path where genesis.json will be stored for a new network; for adding new node, the existing network's genesis.json should be available in json format in this file.|
| bootnode | This is only applicable when adding a new node to existing network and contains the boot node rpc details |


<a name="organizations"></a>
conforganizations
: `organizations` section contains the specifications of each organization.  

In the sample configuration example, we have four organization under the `organizations` section.

The snippet of an organization field with sample values is below
```yaml
--8<-- "platforms/quorum/configuration/samples/network-quorum.yaml:67:73"
```
Each `organization` under the `organizations` section has the following fields. 

| Field                                    | Description                                 |
|------------------------------------------|-----------------------------------------------------|
| name                                        | Name of the organization     |
| external_url_suffix                         | Public url suffix of the cluster.         |
| cloud_provider                              | Cloud provider of the Kubernetes cluster for this organization. This field can be aws, azure, gcp or minikube |
| aws                                         | When the organization cluster is on AWS |
| k8s                                         | Kubernetes cluster deployment variables.|
| vault                                       | Contains Hashicorp Vault server address and root-token in the example |
| gitops                                      | Git Repo details which will be used by GitOps/Flux. |
| services                                    | Contains list of services which could ca/peer/orderers/consensus based on the type of organization |

For the `aws` `vault` and `k8s` field the snippet with sample values is below
```yaml
--8<-- "platforms/quorum/configuration/samples/network-quorum.yaml:74:87"
```

The `aws` field under each organization contains: (This will be ignored if cloud_provider is not `aws`)

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| access_key                              | AWS Access key  |
| secret_key                              | AWS Secret key  |

The `k8s` field under each organization contains

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| context                                 | Context/Name of the cluster where the organization entities should be deployed                                   |
| config_file                             | Path to the kubernetes cluster configuration file                                                                |

The `vault` field under each organization contains

| Field       | Description |
|-------------|----------------------------------------------------------|
| url        | The URL for Hashicorp Vault server with port (Do not use 127.0.0.1 or localhost)  |
| root_token    | The root token for accessing the Vault server    |



For gitops fields the snippet from the sample configuration file with the example values is below
```yaml
--8<-- "platforms/quorum/configuration/samples/network-quorum.yaml:90:100"
```

The gitops field under each organization contains

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| git_protocol | Option for git over https or ssh. Can be `https` or `ssh` |
| git_url                              | SSH or HTTPs url of the repository where flux should be synced                                                            |
| branch                               | Branch of the repository where the Helm Charts and value files are stored                                        |
| release_dir                          | Relative path where flux should sync files                                                                       |
| chart_source                         | Relative path where the helm charts are stored                                                                   |
| git_repo                         | Gitops git repo URL https URL for git push like "github.com/hyperledger/bevel.git"             |
| username                             | Username which has access rights to read/write on repository                                                     |
| password                             | Password of the user which has access rights to read/write on repository (Optional for ssh; Required for https) |
| email                                | Email of the user to be used in git config                                                                       |
| private_key                          | Path to the private key file which has write-access to the git repo (Optional for https; Required for ssh) |

The services field for each organization under `organizations` section of Quorum contains list of `services` which could be only peers as of now.

Each organization with type as peer will have a peers service. The snippet of peers service with example values is below
```yaml
--8<-- "platforms/quorum/configuration/samples/network-quorum.yaml:103:123"
```
The fields under `peer` service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name            | Name of the peer                |
| subject     | This is the alternative identity of the peer node    |
| type           | Type can be `validator` and `nonvalidator`. This is only applicable for `ibft` consensus. |
| geth_passphrase | This is the passphrase used to generate the geth account. |
| p2p.port   | P2P port for Quorum|
| p2p.ambassador | The P2P Port when exposed on ambassador service|
| rpc.port   | RPC port for Quorum|
| rpc.ambassador | The RPC Port when exposed on ambassador service|
| transaction_manager.port   | Port used by Transaction manager `tessera` |
| transaction_manager.ambassador | The tm port when exposed on ambassador service. |
| raft.port   | RAFT port for Quorum when `consensus: raft` |
| raft.ambassador | The RAFT Port when exposed on ambassador service|
| db.port   | MySQL DB internal port, only valid if `transaction_manager: tessera`|



*** feature is in future scope
