[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Configuration file specification: Hyperledger-Fabric
A network.yaml file is the base configuration file designed in Hyperledger Bevel for setting up a Fabric DLT network. This file contains all the information related to the infrastructure and network specifications. 


??? note "Schema Definition"

    A json-schema definition is provided in `platforms/network-schema.json` to assist with semantic validations and lints. You can use your favorite yaml lint plugin compatible with json-schema specification, like `redhat.vscode-yaml` for VSCode. You need to adjust the directive in template located in the first line based on your actual build directory:

    `# yaml-language-server: $schema=../platforms/network-schema.json`

The configurations are grouped in the following sections for better understanding.

* [type](#type)

* [version](#version)

* [frontend](#frontend)

* [env](#env)

* [frontend](#frontend)

* [docker](#docker)

* [consensus](#consensus)

* [orderers](#orderers)

* [channels](#channels)

* [organizations](#organizations)


Before setting up a Fabric DLT/Blockchain network, this file needs to be updated with the required specifications.

Use this [sample configuration file](https://github.com/hyperledger/bevel/blob/main/platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml) as a base. 

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:7:14"
```

<a name="type"></a>
type
: `type` defines the platform choice like corda/fabric/quorum, here in the example it's **Fabric**.

<a name="version"></a>
version
: `version` defines the version of platform being used. The current Fabric version support is 1.4.8, 2.2.2 & 2.5.4

<a name="frontend"></a>
frontend
: `frontend` s a flag which defines if frontend is enabled for nodes or not. Its value can only be enabled/disabled. This is only applicable if the sample Supplychain App is being installed.

<a name="env"></a>
env
: `env` section contains the environment type. Value for proxy field under this section can be 'none' or 'haproxy'

The snapshot of the `env` section with example value is below

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:19:28"
```
The fields under `env` section are 

| Field      | Description                                 |
|------------|---------------------------------------------|
| type       | Environment type. Can be like dev/test/prod.|
| proxy      | Choice of the Cluster Ingress controller. Currently supports 'haproxy' for production/inter-cluster and 'none' for single cluster |
| retry_count       | Retry count for the checks. |
|external_dns       | If the cluster has the external DNS service, this has to be set `enabled` so that the hosted zone is automatically updated. |
|labels| Use this to pass additional labels to the `service`, `deployment` and `pvc` elements of Kubernetes|


<a name="docker"></a>
docker
: `docker` section contains the credentials of the container registry where all the required images are stored.

The snapshot of the `docker` section with example values is below

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:34:40"
```

The fields under `docker` section are

| Field    | Description                            |
|----------|----------------------------------------|
| url      | Docker registry url                    |
| username | Username credential required for login |
| password | Password credential required for login |

!!! tip
    
    Please follow [these instructions](../getting-started/configure-prerequisites.md#docker-images) to build and store the docker images before running the Ansible playbooks.

<a name="consensus"></a>
consensus
: `consensus` section contains the consensus service that uses the orderers provided in the following `orderers` section.

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:44:45"
```

The fields under the each `consensus` are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name        | Name of the Consensus service. Can be `raft` or `kafka`. |

<a name="orderers"></a>
orderers
: `orderers` section contains a list of orderers with variables which will expose it for the network.

The snapshot of the `orderers` section with example values is below

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:46:61"
```

The fields under the each `orderer` are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name        | Name of the orderer service                                  |
| type        | For Fabric, `orderer` is the only valid type of orderers.   |
| org_name    | Name of the organization to which this orderer belongs to |
| uri         | Orderer URL which is accessible by all Peers. This must include the port even when running on 443                                              |


<a name="channels"></a>
channels
: The `channels` sections contains the list of channels mentioning the participating peers of the organizations.

The snapshot of channels section with its fields and sample values is below

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:63:165"
```

The fields under the `channel` are

| Field                           | Description                                                |
|---------------------------------|------------------------------------------------------------|
| consortium                      | Name of the consortium, the channel belongs to             |
| channel_name                    | Name of the channel                                        |
| osn_creator_org.name            | Name of the organization whose orderers will create the channel                                 |
| chaincodes                      | Contains list of chaincodes for the channel                |
| genesis.name                    | Name of the genesis block                                  |
| orderers                        | List of names of the organizations providing ordering service           |
| participants                    | Contains list of organizations participating in the channel|
| endorsers                       | Contains list of organizations (v2.2+)                     |
| channel_status                  | Mainly needed to add channel to existing org. Possible values are `new` or `existing`|

Each `organization` field under `participants` field of the channel contains the following fields

| Field                           | Description                                                |
|---------------------------------|------------------------------------------------------------|
| name               | Organization name of the peer participating in the channel |
| type               | This field can be creator/joiner of channel                |
| org_status         | `new` (for initial setup) or `existing` (for add new org) | 
| ordererAddress     | URL of the orderer this peer connects to, including port                  |
| peer.name          | Name of the peer                                           |
| peer.type                          | Type can be `anchor` and `nonanchor` for Peer                                                                    |
| peer.gossipAddress | Gossip address of the peer, including port                               |
| peer.peerAddress | External address of the peer, including port                                  |

Each `organization` field under `endorsers` field of the channel contains the following fields

| Field                           | Description                                                |
|---------------------------------|------------------------------------------------------------|
| name                 | Endorser name                                                         |
| peer.name            | Name of the peer                                                      |
| peer.corepeerAddress | Endorsers addresses, including port                                                    |
| peer.certificate     | Certificate path for peer                                             |



<a name="organizations"></a>
organizations
: The `organizations` section contains the specifications of each organization.  

In the sample configuration example, we have five organization under the `organizations` section

The snapshot of an organization field with sample values is below

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:167:185"
```

Each `organization` under the `organizations` section has the following fields. 

| Field                                    | Description                                 |
|------------------------------------------|-----------------------------------------------------|
| name                                        | Name of the organization                                                                                         |
| country                                     | Country of the organization                                                                                      |
| state                                       | State of the organization                                                                                        |
| location                                    |  Location of the organization                                                                                    |
| subject                                     | Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
| external_url_suffix                         | Public url suffix of the cluster.         |
| org_status         | `new` (for initial setup) or `existing` (for add new org) |
| orderer_org        |  Ordering service provider.                              |  
| ca_data                                     | Contains the certificate path; this has not been implemented yet |
| cloud_provider                              | Cloud provider of the Kubernetes cluster for this organization. This field can be aws, azure, gcp or minikube |
| aws                                         | When the organization cluster is on AWS |
| k8s                                         | Kubernetes cluster deployment variables.|
| vault                                       | Contains Hashicorp Vault server address and root-token in the example |
| gitops                                      | Git Repo details which will be used by GitOps/Flux. |
| services                                    | Contains list of services which could ca/peer/orderers/consensus based on the type of organization |

For the aws and k8s field the snapshot with sample values is below

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:186:202"
```

The `aws` field under each organization contains: (This will be ignored if cloud_provider is not 'aws')

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| access_key                              | AWS Access key  |
| secret_key                              | AWS Secret key  |

The `k8s` field under each organization contains

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| region                                  | Region where the Kubernetes cluster is deployed, e.g : eu-west-1        |
| context                                 | Context/Name of the cluster where the organization entities should be deployed                                   |
| config_file                             | Path to the kubernetes cluster configuration file                                                                |

The `vault` field under each organization contains

| Field       | Description |
|-------------|----------------------------------------------------------|
| url        | The URL for Hashicorp Vault server with port (Do not use 127.0.0.1 or localhost)  |
| root_token    | The root token for accessing the Vault server    |

For gitops fields the snapshot from the sample configuration file with the example values is below

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:203:216"
```

The gitops field under each organization contains

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| git_protocol | Option for git over https or ssh. Can be `https` or `ssh` |
| git_url                              | SSH or HTTPs url of the repository where flux should be synced                                                            |
| branch                               | Branch of the repository where the Helm Charts and value files are stored                                        |
| release_dir                          | Relative path where flux should sync files                                                                       |
| component_dir                        | Relative path where values files are stored.files                                                                       |
| chart_source                         | Relative path where the helm charts are stored                                                                   |
| git_repo                         | Gitops git repo URL https URL for git push like "github.com/hyperledger/bevel.git"             |
| username                             | Username which has access rights to read/write on repository                                                     |
| password                             | Password of the user which has access rights to read/write on repository (Optional for ssh; Required for https)        |
| email                                | Email of the user to be used in git config                                                                       |
| private_key                          | Path to the private key file which has write-access to the git repo (Optional for https; Required for ssh)       |

For Hyperledger Fabric, you can also generate different user certificates and pass the names and attributes in the specific section for `users`. This is only applicable if using Fabric CA. An example is below:

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:340:346"
```

The fields under `user` are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| identity          | The name of the user        |
| attribute   | key value pair for the different attributes supported in Fabric, details about the attributes are [here](https://hyperledger-fabric-ca.readthedocs.io/en/latest/users-guide.html#attribute-based-access-control) |


The services field for each organization under `organizations` section of Fabric contains list of `services` which could be ca/orderers/consensus/peers based on if the type of organization. 

Each organization will have a CA service under the service field. The snapshot of CA service with example values is below

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:218:226"
```

The fields under `ca` service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name                             | Certificate Authority service name        |
| subject                         | Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
| type | Type must be `ca` for certification authority |
| grpc.port                       | Grpc port number |


Example of peer service. Below is a snapshot of the peer service with example values.

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:356:389"
```

The fields under `peer` service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name                          | Name of the peer. Must be of the format `peer0` for the first peer, `peer1` for the second peer and so on.       |
| type                          | Type can be `anchor` and `nonanchor` for Peer                                                                    |
| gossippeeraddress             | Gossip address of another peer in the same Organization, including port. If there is only one peer, then use that peer address. Can be internal if the peer is hosted in the same Kubernetes cluster. |
| peerAddress             | External address of this peer, including port. Must be the HAProxy qualified address. If using single cluster, this can be internal address. |
| cli             | Optional field. If `enabled` will deploy the CLI pod for this Peer. Default is `disabled`. |
| configpath | This field is mandatory for using external chaincode. This is the path where a custom core.yaml will be used for the peer. |
| grpc.port                     | Grpc port                                                                                                        |
| events.port                   | Events port                                                                                                      |
| couchdb.port                  | Couchdb port                                                                                                     |
| restserver.targetPort         | Restserver target port                                                                                           |
| restserver.port               | Restserver port                                                                                                  |
| expressapi.targetPort         | Express server target port                                                                                       |
| expressapi.port               | Express server port                                                                                              |
| metrics.enabled               | Enable metrics (ensure serviceMonitor CRD is present before enabling metrics)                                    |
| metrics.port                  | Metrics Port                                                                                                     |

The chaincodes section contains the list of chaincode for the peer, the fields under each chaincode are below

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name                | Name of the chaincode                                                                                            |
| version             | Version of the chaincode. Please do not use . (dot) in the version.    |
| external_chaincode | This is mandatory to be `true` when using external chaincode |
| maindirectory       | Path of main.go file, optional for external_chaincode                        |
| lang                | The language in which the chaincode is written ( golang/ java), optional for external_chaincode                |
| repository.username | Username which has access to the git repo containing chaincode, optional for external_chaincode    |
| repository.password | Password of the user which has access to the git repo containing chaincode, optional for external_chaincode|
| repository.url      | URL of the git repository containing the chaincode, optional for external_chaincode  |
| repository.branch   | Branch in the repository where the chaincode resides, optional for external_chaincode |
| repository.path     | Path of the chaincode in the repository branch, optional for external_chaincode    |
| arguments           | Init Arguments to the chaincode, mandatory for both chaincode types     |
| endorsements        | Endorsements (if any) provided along with the chaincode, optional for external_chaincode |
| tls | Mandatory for external_chaincode, marks the chaincode as tls enabled |
| buildpack_path | Mandatory for external_chaincode, Path from where the buildpack will be uploaded to the peer, ensure the core.yaml has been also updated correctly |
| image | Mandatory for external_chaincode, the container from docker registry applicable for this chaincode. For private registry, ensure password is passed in `network.docker` section |
| crypto_mount_path | Required only when `tls: true`, the path where the crypto materials will be stored |

The organization with orderer type will have consensus service. The snapshot of consensus service with example values is below

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:228:229"
```

The fields under `consensus` service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name                     | Name of the Consensus service. Can be `raft` or `kafka`.      |
| type                      | Only for `kafka`. Consensus service type, only value supported is `broker` currently  |
| replicas                  | Only for `kafka`. Replica count of the brokers  |
| grpc.port                 | Only for `kafka`. Grpc port of consensus service |

Example of ordering service. The snapshot of orderers service with example values is below

```yaml
--8<-- "platforms/hyperledger-fabric/configuration/samples/network-fabricv2.yaml:230:254"
```

The fields under `orderer` service are

| Field       | Description                                              |
|-------------|----------------------------------------------------------|
| name                        | Name of the Orderer service                                                                                                     |
| type          | This type must be `orderer`  |
| consensus                   | Consensus type, for example: `kafka`, `raft`                                                                               |
| status                   | (Only needed to add new orderer). Possible values are `new` or `existing`                                                                                             |
| grpc.port                   | Grpc port of orderer                                                                                             |
|ordererAddress| Accessible address of the Orderer, including port |
| metrics.enabled               | Enable metrics (ensure serviceMonitor CRD is present before enabling metrics)                                    |
| metrics.port                  | Metrics Port                                                                                                     |
