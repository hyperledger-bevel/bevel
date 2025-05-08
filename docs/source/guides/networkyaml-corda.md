[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)
# Configuration file specification: R3 Corda
A `network.yaml` configuration file serves as a centralized and comprehensive blueprint, capturing the essential parameters and configurations needed to set up the entire Corda DLT network. It allows the users to define the network ports, participant nodes, notary service urls, and various parameters crucial for the network's operation. This file needs to be updated for your specific network setup before using it with the Ansible playbooks.

??? note "Schema Definition"

    A json-schema definition is provided in `platforms/network-schema.json` to assist with semantic validations and lints. You can use your favorite yaml lint plugin compatible with json-schema specification, like `redhat.vscode-yaml` for VSCode. You need to adjust the directive in template located in the first line based on your actual build directory:

    `# yaml-language-server: $schema=../platforms/network-schema.json`

The configurations are grouped in the following sections for better understanding.

* [type](#type)

* [version](#version)

* [env](#env)

* [docker](#docker)

* [network_services](#network_services)

* [organizations](#organizations)

Although, the file itself has comments for each key-value, here is a more detailed description with respective snippets.
=== "Corda Opensource"
    Use this [sample configuration file](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda/configuration/samples/network-cordav2.yaml) as a base.
    ```yaml
    --8<-- "platforms/r3-corda/configuration/samples/network-cordav2.yaml:7:14"
    ```
=== "Corda Enterprise"
    Use this [sample configuration file](https://github.com/hyperledger/bevel/blob/main/platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml) as a base.
    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:7:14"
    ```
<a name="type"></a>
type
: `type` defines the platform choice like corda/fabric/quorum. Use `corda` for **Corda Opensource** and `corda-enterprise` for **Corda Enterprise**.

<a name="version"></a>
version
: `version` defines the version of platform being used, here in example the Corda version is 4.9. Please note only 4.4 above is supported for **Corda Enterprise**.

<a name="env"></a>
env
: `env` section contains the kubernetes settings like flux tag, proxy etc. as describe below.

```yaml
--8<-- "platforms/r3-corda/configuration/samples/network-cordav2.yaml:16:27"
```
The fields under `env` section are 

| Field      | Description        |
|------------|---------------------------------------------|
| type       | Environment type. Can be like dev/test/prod.|
| proxy      | Choice of the Cluster Ingress controller. Currently supports `ambassador` only as `haproxy` has not been implemented for Corda |
| ambassadorPorts   | Any additional Ambassador ports can be given here. This is only valid if `proxy: ambassador`     |
| loadBalancerSourceRanges | (Optional) Restrict inbound access to a single or list of IP addresses for the public Ambassador ports to enhance network security. This is only valid if `proxy: ambassador`.  |
| retry_count       | Retry count for the checks. Use a large number if your kubernetes cluster is slow. |
| external_dns       | If the cluster has the [external DNS service](../tutorials/dns-settings.md#external-dns), this has to be set `enabled` so that the hosted zone is automatically updated. |

<a name="docker"></a>
docker
: `docker` section contains the credentials of the container registry where all the required images are stored.

=== "Corda Opensource"
    The following images are used and needed by Hyperledger Bevel.

    * [Corda Network Map Service](https://github.com/hyperledger/bevel/pkgs/container/bevel-networkmap-linuxkit) 
    * [Corda Doorman Service](https://github.com/hyperledger/bevel/pkgs/container/bevel-doorman-linuxkit)
    * [Corda Node](https://github.com/hyperledger/bevel/pkgs/container/bevel-corda)

=== "Corda Enterprise"
    For **Corda Enterprise**, all Docker images must be built and stored in a private Docker registry before running the Ansible playbooks. The required instructions are found [here](../getting-started/configure-prerequisites.md#corda-enterprise-docker-images).

```yaml
--8<-- "platforms/r3-corda/configuration/samples/network-cordav2.yaml:28:34"
```
The fields under `docker` section are

| Field      | Description        |
|------------|---------------------------------------------|
| url        | Docker registry url. Must be private registry for **Corda Enterprise**    | 
| username   | Username credential required for login      |
| password   | Password or Access token required for login      |

!!! note
    Please follow [these instructions](../getting-started/configure-prerequisites.md#docker-images) to build and store the docker images before running the Ansible playbooks.

<a name="network_services"></a>
network_services
: The `network_services` section contains a list of doorman/idman/networkmap which is exposed to the network.

=== "Corda Opensource"
    ```yaml
    --8<-- "platforms/r3-corda/configuration/samples/network-cordav2.yaml:35:44"
    ```
=== "Corda Enterprise"
    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:38:52"
    ```

Each `service` has the following fields:
=== "Corda Opensource"
    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | type        | For Corda, `networkmap` and `doorman` are the only valid type of network_services.    |
    | uri         | Doorman/Networkmap external URL. This should be reachable from all nodes.     | 
    | certificate | Absolute path to the public certificates for Doorman/IDman and Networkmap.             |

=== "Corda Enterprise"
    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | type        | For Corda Enterprise, `networkmap` and `idman` are the only valid type of network_services.    |
    | name | Name of the idman/networkmap service. |
    | uri         | Doorman/IDman/Networkmap external URL. This should be reachable from all nodes.     | 
    | certificate | Absolute path to the public certificates for Doorman/IDman and Networkmap.             |
    | crlissuer_subject | Only for **Idman**. Subject of the CRL Issuer.|
    | truststore | Only for **Networkmap**. Absolute path to the base64 encoded networkroot truststore.|
    | truststore_pass | Only for **Networkmap**. Truststore password |

<a name="organizations"></a>
organizations
: The `organizations` section allows specification of one or many organizations that will be connecting to a network. If an organization is also hosting the root of the network (e.g. doorman, membership service, etc), then these services should be listed in this section as well.

In the sample example the 1st organization is hosting the root of the network, so the services doorman, nms and notary are listed under the 1st organization's service.

A snippet of an `organization` field with sample values is below

=== "Corda Opensource"
    ```yaml
    --8<-- "platforms/r3-corda/configuration/samples/network-cordav2.yaml:48:57"
    ```
=== "Corda Enterprise"
    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:57:68"
    ```

Each organization under the `organizations` section has the following fields. 
=== "Corda Opensource"

    | Field           | Description        |
    |------------------------------------------|-----------------------------------------------------|
    | name          | Name of the organization  |
    | country       | Country of the organization    |
    | state         | State of the organization   |
    | location      |  Location of the organization   |
    | subject       | Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
    | type   | This field can be doorman-nms-notary/node             |
    | external_url_suffix     | Public url suffix of the cluster. This is the configured path for the Ambassador Service on the DNS provider.|
    | cloud_provider           | Cloud provider of the Kubernetes cluster for this organization. This field can be aws, azure or gcp |
    | aws           | When the organization cluster is on AWS |
    | k8s           | Kubernetes cluster deployment variables.|
    | vault         | Contains Hashicorp Vault server address and root-token in the example |
    | gitops        | Git Repo details which will be used by GitOps/Flux. |
    | cordapps (optional) | Cordapps Repo details which will be used to store/fetch cordapps jar |
    | services      | Contains list of services which could be peers/doorman/nms/notary |

=== "Corda Enterprise"

    | Field           | Description        |
    |------------------------------------------|-----------------------------------------------------|
    | name               | Name of the organization   |
    | country            | Country of the organization     |
    | state              | State of the organization          |
    | location           |  Location of the organization         |
    | subject            | Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
    | subordinate_ca_subject | Subordinate CA Subject for the CENM.|
    | type               | This field can be cenm/node.             |
    | version            | Defines the CENM version. Must be `1.5` |
    | external_url_suffix| Public url suffix of the cluster. This is the configured path for the Ambassador Service on the DNS provider.|
    | cloud_provider     | Cloud provider of the Kubernetes cluster for this organization. This field can be aws, azure or gcp |
    | aws                | When the organization cluster is on AWS |
    | k8s                | Kubernetes cluster deployment variables.|
    | vault              | Contains Hashicorp Vault server address and root-token in the example |
    | gitops             | Git Repo details which will be used by GitOps/Flux. |
    | firewall           | Contains firewall options and credentials |
    | cordapps (optional)| Cordapps Repo details which will be used to store/fetch cordapps jar |
    | services           | Contains list of services which could be peers/doorman/nms/notary/idman/signer |

For the `aws`, `k8s` and `vault` fields, a snippet is below
```yaml
--8<-- "platforms/r3-corda/configuration/samples/network-cordav2.yaml:58:70"
```

The `aws` field under each organization contains: (This will be ignored if cloud_provider is not `aws``)

| Field       | Description |
|-------------|----------------------------------------------------------|
| access_key     | AWS Access key  |
| secret_key     | AWS Secret key  |

The `k8s` field under each organization contains

| Field       | Description |
|-------------|----------------------------------------------------------|
| context        | Context/Name of the cluster where the organization entities should be deployed          |
| config_file    | Path to the kubernetes cluster configuration file                   |

The `vault` field under each organization contains

| Field       | Description |
|-------------|----------------------------------------------------------|
| url        | The URL for Hashicorp Vault server with port (Do not use 127.0.0.1 or localhost)  |
| root_token    | The root token for accessing the Vault server    |

For `gitops` field, the snippet from the sample configuration file is below
```yaml
--8<-- "platforms/r3-corda/configuration/samples/network-cordav2.yaml:71:83"
```

The `gitops` field under each organization contains

| Field       | Description |
|-------------|----------------------------------------------------------|
| git_protocol | Option for git over https or ssh. Can be `https` or `ssh` |
| git_url     | SSH or HTTPs url of the repository where flux should be synced               |
| branch      | Branch of the repository where the Helm Charts and value files are stored               |
| release_dir | Relative path where flux should sync files                          |
| chart_source| Relative path where the helm charts are stored                      |
| git_repo| Gitops git repo URL https URL for git push like "github.com/hyperledger/bevel.git"             |
| username    | Username which has access rights to read/write on repository        |
| password    | Access token of the user which has access rights to read/write on repository (Optional for ssh; Required for https)  |
| email       | Email of the user to be used in git config                          |
| private_key | Path to the private key file which has write-access to the git repo (Optional for https; Required for ssh)       |   

=== "Corda Opensource"
    Corda Opensource does not have `credentials` section.
=== "Corda Enterprise"
    The `credentials` field under each organization contains

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | keystore    | Contains passwords for keystores|
    | truststore  | Contains passwords for truststores   |
    | ssl         | Contains passwords for ssl keystores |

    For organization as type `cenm` the credential block looks like
    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:111:128"
    ```
    For organization as type `node` the credential section is under peers section and looks like
    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:234:237"
    ```

For `cordapps` fields, a snippet from the sample configuration file is below:
```yaml
--8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:99:109"
```

The `cordapps` optional field under each organization contains

| Field       | Description |
|-------------|----------------------------------------------------------|
| jars        | Contains list of jars with jar URL that needs to fetched and put into organization nodes    |
| username    | Cordapps Repository username |
| password    | Cordapps Repository password |

=== "Corda Opensource"
    Corda Opensource does not have `firewall` section.
=== "Corda Enterprise"
    The `firewall` section contains Corda Enterprise firewall configuration for each `organization`.
    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:231:237"
    ```

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | enabled     | true/false for enabling firewall (external bridge and float)   |
    | subject     | Certificate Subject for firewall, format at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
    | credentials | Contains credentials for bridge and float                |

The `services` field for each organization under `organizations` section of Corda contains list of services which could be doorman/idman/nms/notary/peers for opensource, and additionally idman/networkmap/signer/bridge/float for **Corda Enterprise**.

For **doorman/idman**

=== "Corda Opensource"
    A snippet of `doorman` service is below:
    ```yaml
    --8<-- "platforms/r3-corda/configuration/samples/network-cordav2.yaml:99:108"
    ```
    The fields under `doorman` service are 

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | name            | Name for the Doorman service                                    |
    | subject| Certificate Subject for Doorman service. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
    | db_subject                 | Certificate subject for mongodb database of doorman
    | type   | Service type must be `doorman`                                |
    | ports.servicePort          | HTTP port number where doorman service is accessible              |
    | ports.targetPort           | HTTP target port number of the doorman docker-container              |
    | tls    | On/off based on whether we want TLS on/off for doorman 

=== "Corda Enterprise"
    A snippet of `idman` service is below:
    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:153:158"
    ```
    The fields under `idman` service are 

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | name            | Name for the IDman service                                    |
    | subject| Certificate Subject for Idman service. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
    | crlissuer_subject                 | Certificate subject for CRL Issuer service |
    | type   | Service type must be `cenm-idman`                                |
    | port          | HTTP port number where idman service is accessible internally            |

For **networkmap**
=== "Corda Opensource"
    A snippet of `nms` service is below:
    ```yaml
    --8<-- "platforms/r3-corda/configuration/samples/network-cordav2.yaml:109:117"
    ```
    The fields under `nms` service are

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | name                | Name of the NetworkMap service |
    | subject      | Certificate Subject for NetworkMap service. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
    | db_subject              | Certificate subject for mongodb database of nms.
    | type| Service type must be `networkmap`    |
    | ports.servicePort       | HTTP port number where NetworkMap service is accessible              |
    | ports.targetPort        | HTTP target port number of the NetworkMap docker-container         |
    | tls | On/off based on whether we want TLS on/off for nms

=== "Corda Enterprise"
    A snippet of `networkmap` service is below:
    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:159:165"
    ```
    The fields under `networkmap` service are 

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | name            | Name for the Networkmap service                                    |
    | subject| Certificate Subject for Networkmap service. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
    | type   | Service type must be `cenm-networkmap`                                |
    | ports.servicePort          | HTTP port number where networkmap service is accessible internally              |
    | ports.targetPort           | HTTP target port number of the networkmap docker-image              |

For **notary**
=== "Corda Opensource"
    A snippet of `notary` service is below
    ```yaml
    --8<-- "platforms/r3-corda/configuration/samples/network-cordav2.yaml:118:140"
    ```
    The fields under `notary` service are 

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | name | Name of the notary service   |
    | subject                   | Certificate Subject for notary node. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
    | serviceName            | Certificate Subject for notary service applicable from Corda 4.7 onwards. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
    | type  | Service type must be `notary`  |
    | validating | Determines if Notary is validating or non-validating. Use `true` or `false` |
    | p2p.port                  | Corda Notary P2P port. Used for communication between the notary and nodes of same network|
    | p2p.targetport            | P2P Port where notary service is running. |
    | p2p.ambassador        | Port where notary service is exposed via Ambassador|
    | rpc.port                  | Corda Notary RPC port. Used for communication between the notary and nodes of same network|
    | rpcadmin.port             | Corda Notary Rpcadmin port. Used for RPC admin binding|
    | dbtcp.port                | Corda Notary DbTcp port. Used to expose database to other services                |
    | dbtcp.targetPort          | Corda Notary DbTcp target port. Port where the database services are running      |
    | dbweb.port                | Corda Notary dbweb port. Used to expose dbweb to other services                   |
    | dbweb.targetPort          | Corda Notary dbweb target port. Port where the dbweb services are running         |

=== "Corda Enterprise"
    A snippet of `notary` service is below:
    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:173:196"
    ```
    The fields under `notary` service are 

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | name | Name of the notary service   |
    | subject                   | Certificate Subject for notary node. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
    | serviceName            | Certificate Subject for notary service applicable from Corda 4.7 onwards. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
    | type  | Service type must be `notary`  |
    | validating | Determines if Notary is validating or non-validating. Use `true` or `false` |
    | emailAddress | Email address in the notary conf. |
    | p2p.port                  | Corda Notary P2P port. Used for communication between the notary and nodes of same network|
    | p2p.targetport            | P2P Port where notary service is running. |
    | p2p.ambassador            | Port where notary service is exposed via Ambassador|
    | rpc.port                  | Corda Notary RPC port. Used for communication between the notary and nodes of same network|
    | rpcadmin.port             | Corda Notary Rpcadmin port. Used for RPC admin binding|
    | dbtcp.port                | Corda Notary DbTcp port. Used to expose database to other services                |
    | dbtcp.targetPort          | Corda Notary DbTcp target port. Port where the database services are running      |
    | dbweb.port                | Corda Notary dbweb port. Used to expose dbweb to other services                   |
    | dbweb.targetPort          | Corda Notary dbweb target port. Port where the dbweb services are running         |

For **peers/nodes**
=== "Corda Opensource"
    A snippet of `peer` service is below:
    ```yaml
    --8<-- "platforms/r3-corda/configuration/samples/network-cordav2.yaml:196:223"
    ```
    The fields under each `peer` service are 

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | name | Name of the Corda Node                                              |
    | subject   | The node legal name as certificate subject. |
    | type | Service type must be `node` |
    | p2p.port  | Corda Node P2P port.Used for communication between the nodes  of same network           |
    | p2p.targetport            | P2P Port where node service is running. |
    | p2p.ambassador            | Port where node service is exposed via Ambassador|
    | rpc.port  | Corda Node RPC port. Used for communication between the nodes of different network      |
    | rpcadmin.port                 | Corda Node Rpcadmin port. Used for RPC admin binding                |
    | dbtcp.port| Corda Node DbTcp port. Used to expose database to other services                  |
    | dbtcp.targetPort              | Corda Node DbTcp target port. Port where the database services are running      |
    | dbweb.port| Corda Node dbweb port. Used to expose dbweb to other services       |
    | dbweb.targetPort              | Corda Node dbweb target port. Port where the dbweb services are running               |
    | springboot.port               | Springboot server port. Used to expose springboot to other    services                  |
    | springboot.targetPort         | Springboot server  target port. Port where the springboot services are running      |
    | expressapi.port               | Expressapi port. Used to expose expressapi to other services        |
    | expressapi.targetPort         | Expressapi target port. Port where the expressapi services are running               |

=== "Corda Enterprise"
    A snippet of `peer` service is below:
    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:316:347"
    ```

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | name | Name of the Corda Node                                              |
    | subject   | The node legal name subject. |
    | type | Service type must be `node` |
    | credentials | The passwords as described in `credentials` section above. |
    | hsm | This is for future use with HSM. |
    | p2p.port  | Corda Node P2P port.Used for communication between the nodes  of same network           |
    | p2p.targetport            | P2P Port where node service is running. |
    | p2p.ambassador            | Port where node service is exposed via Ambassador|
    | rpc.port  | Corda Node RPC port. Used for communication between the nodes of different network      |
    | rpcadmin.port                 | Corda Node Rpcadmin port. Used for RPC admin binding                |
    | dbtcp.port| Corda Node DbTcp port. Used to expose database to other services                  |
    | dbtcp.targetPort              | Corda Node DbTcp target port. Port where the database services are running      |
    | dbweb.port| Corda Node dbweb port. Used to expose dbweb to other services       |
    | dbweb.targetPort              | Corda Node dbweb target port. Port where the dbweb services are running               |
    | springboot.port               | Springboot server port. Used to expose springboot to other    services                  |
    | springboot.targetPort         | Springboot server  target port. Port where the springboot services are running      |
    | expressapi.port               | Expressapi port. Used to expose expressapi to other services        |
    | expressapi.targetPort         | Expressapi target port. Port where the expressapi services are running               |

There are additional services for **Corda Enterprise**.
=== "Corda Opensource"
    Corda Opensource does not support CENM or other advanced features.

=== "Corda Enterprise"
    A snippet of `zone` service is below
    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:132:138"
    ```
    The fields under `zone` service are 

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | name            | Name for the Zone service                                    |
    | type   | Service type must be `cenm-zone`                                |
    | ports.enm          | HTTP enm port number where zone service is accessible internally            |
    | ports.admin          | HTTP admin port number of zone service            |

    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:139:145"
    ```
    The fields under `auth` service are 

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | name            | Name for the Auth service                                    |
    | subject| Certificate Subject for Auth service. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
    | type   | Service type must be `cenm-auth`                                |
    | ports          | HTTP port number where auth service is accessible internally            |
    | username          | Admin user name for auth service            |
    | userpwd          | Admin password for auth service            |

    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:146:152"
    ```
    The fields under `gateway` service are 

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | name            | Name for the Gateway service                                    |
    | subject| Certificate Subject for Gateway service. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
    | type   | Service type must be `cenm-gateway`                                |
    | ports.servicePort          | HTTP port number where gateway service is accessible internally            |
    | ports.ambassadorPort          | Port where gateway service is exposed via Ambassador            |

    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:166:172"
    ```
    The fields under `signer` service are 

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | name            | Name for the Signer service                                    |
    | subject| Certificate Subject for Signer service. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
    | type   | Service type must be `cenm-signer`                                |
    | ports.servicePort          | HTTP port number where signer service is accessible              |
    | ports.targetPort           | HTTP target port number of the signer docker-container              |

    A snippet of `float` service is below:
    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:283:312"
    ```
    The **Float** service is supposed to be in a different Kubernetes cluster and so some fields are repeated, but must be updated with a different cluster details. The fields under `float` service are:

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | name            | Name for the float service                                    |
    | subject| Certificate Subject for Float service. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
    | external_url_suffix| Public url suffix of the cluster. This is the configured path for the Ambassador Service on the DNS provider.|
    | cloud_provider     | Cloud provider of the Kubernetes cluster for this organization. This field can be aws, azure or gcp |
    | aws                | When the organization cluster is on AWS |
    | k8s                | Kubernetes cluster deployment variables.|
    | vault              | Contains Hashicorp Vault server address and root-token in the example |
    | gitops             | Git Repo details which will be used by GitOps/Flux. |
    | ports.p2p_port     | Peer to peer service port  |
    | ports.tunnel_port  | Tunnel port for tunnel between float and bridge service |
    | port.ambassador_tunnel_port                 | Ambassador port for tunnel between float and bridge service |
    | ambassador_p2p_port             | Ambassador port Peer to peer connection |

    A snippet of `bridge` service is below:
    ```yaml
    --8<-- "platforms/r3-corda-ent/configuration/samples/network-cordaent.yaml:313:315"
    ```
    The fields under `bridge` service are below:

    | Field       | Description |
    |-------------|----------------------------------------------------------|
    | name            | Name for the bridge service                                    |
    | subject| Certificate Subject for bridge service. Subject format can be referred at [OpenSSL Subject](https://www.openssl.org/docs/man1.0.2/man1/openssl-req.html) |
