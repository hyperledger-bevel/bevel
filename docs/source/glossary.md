[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

Glossary
========
## General

This section lists the general terms that are used in Hyperledger Bevel.

### Ansible
Ansible is an open-source software provisioning, configuration management, and application-deployment tool. It runs on many Unix-like systems, and can configure both Unix-like systems as well as Microsoft Windows. It includes its own declarative language to describe system configuration.
For more details, refer: [Ansible](https://docs.ansible.com/)
### AWS
Amazon Web Services is a subsidiary of Amazon that provides on-demand cloud computing platforms to individuals, companies, and governments, on a metered pay-as-you-go basis.
For more details, refer: [AWS](https://aws.amazon.com/)
### AWS EKS
Amazon Elastic Container Service for Kubernetes (Amazon EKS) is a managed service that makes it easy for users to run Kubernetes on AWS without needing to stand up or maintain your own Kubernetes control plane. Since Amazon EKS is a managed service it handles tasks such as provisioning, upgrades, and patching.
For more details, refer: [EKS](https://aws.amazon.com/eks/)
### Blockchain as a Service (BaaS)
Blockchain-as-a-Service platform is a full-service cloud-based solution that enables developers, entrepreneurs, and enterprises to develop, test, and deploy blockchain applications and smart contracts that will be hosted on the BaaS platform.
### Charts
Helm uses a packaging format called charts. A chart is a collection of files that describe a related set of Kubernetes resources. A single chart might be used to deploy something simple, like a memcached pod, or something complex, like a full web app stack with HTTP servers, databases, caches, and so on.
For more details, refer: [Helm Charts](https://helm.sh/docs/developing_charts/)
### CI/CD
CI and CD are two acronyms that are often mentioned when people talk about modern development practices. CI is straightforward and stands for continuous integration, a practice that focuses on making preparing a release easier. But CD can either mean continuous delivery or continuous deployment, and while those two practices have a lot in common, they also have a significant difference that can have critical consequences for a business.
### CLI
A command-line interface (CLI) is a means of interacting with a computer program where the user (or client) issues commands to the program in the form of successive lines of text (command lines).
### Cluster
In Kubernetes, a cluster consists of at least one cluster Main node and multiple worker machines called nodes.
For more details, refer: [Cluster](https://cloud.google.com/kubernetes-engine/docs/concepts/cluster-architecture)
### Deployment
Software deployment is all of the activities that make a software system available for use. The general deployment process consists of several interrelated activities with possible transitions between them. These activities can occur at the producer side or at the consumer side or both.
### DLT
Distributed Ledger Technology (DLT) is a digital system for recording the transaction of assets in which the transactions and their details are recorded in multiple places at the same time. Unlike traditional databases, distributed ledgers have no central data store or administration functionality.
For more details, refer: [DLT](https://en.wikipedia.org/wiki/Distributed_ledger)
### Docker
Docker is a set of platform-as-a-service products that use OS-level virtualization to deliver software in packages called containers. Containers are isolated from one another and bundle their own software, libraries and configuration files; they can communicate with each other through well-defined channels.
For more details, refer: [Docker](https://www.docker.com/)
### Flux
Flux is the operator that makes GitOps happen in a cluster. It ensures that the cluster config matches the one in git and automates your deployments. Flux enables continuous delivery of container images, using version control for each step to ensure deployment is reproducible, auditable and revertible. Deploy code as fast as your team creates it, confident that you can easily revert if required.
For more details, refer: [Flux](https://www.weave.works/oss/flux/)
### Git
Git is a distributed version-control system for tracking changes in source code during software development. It is designed for coordinating work among programmers, but it can be used to track changes in any set of files. Its goals include speed, data integrity, and support for distributed, non-linear workflows
For more details, refer: [GIT](https://git-scm.com/)
### Gitops
GitOps is a method used for Continuous Delivery. It uses Git as a single source of truth for infrastructures like declarative infrastructure and the applications.
For more details, refer: [Gitops](https://www.weave.works/technologies/gitops/)
### HashiCorp Vault
HashiCorp Vault is a tool for securely accessing secrets. A secret is anything that you want to tightly control access to, such as API keys, passwords, or certificates. Vault provides a unified interface to any secret, while providing tight access control and recording a detailed audit log. For more details, refer: [Vault](https://www.vaultproject.io/docs/what-is-vault/index.html)
### HashiCorp Vault Client
A Vault client is any stand-alone application or integrated add-in that connects to the vault server to access files and perform vault operations.
### Helm
Helm is the first application package manager running atop Kubernetes. It allows describing the application structure through convenient helm-charts and managing it with simple commands.
For more details, refer: [Helm](https://helm.sh/docs/)
### Hosts
A Host is either a physical or virtual machine.
### IAM user
An AWS Identity and Access Management (IAM) user is an entity that you create in AWS to represent the person or application that uses it to interact with AWS. A user in AWS consists of a name and credentials.
For more details, refer: [IAM Users](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html)
### IOT
The Internet of Things is simply "A network of Internet connected objects able to collect and exchange data." It is commonly abbreviated as IoT. In a simple way to put it, You have "things" that sense and collect data and send it to the internet.
For more details, refer: [IOT](https://en.wikipedia.org/wiki/Internet_of_things)
### Instance
A “cloud instance” refers to a virtual server instance from a public or private cloud network. In cloud instance computing, single hardware is implemented into software and run on top of multiple computers.
### Jenkins
Jenkins is a free and open source automation server written in Java. Jenkins helps to automate the non-human part of the software development process, with continuous integration and facilitating technical aspects of continuous delivery. 
For more details, refer: [Jenkins](https://jenkins.io/)
### Jenkins Stages
A stage block in Jenkins defines a conceptually distinct subset of tasks performed through the entire Pipeline (e.g. "Build", "Test" and "Deploy" stages), which is used by many plugins to visualize or present Jenkins Pipeline status/progress.
### Kubeconfig File
A kubeconfig file is a file used to configure access to Kubernetes when used in conjunction with the kubectl command line tool (or other clients). This is usually referred to an environment variable called KUBECONFIG.
### Kubernetes
Kubernetes (K8s) is an open-source container-orchestration system for automating application deployment, scaling, and management. It was originally designed by Google, and is now maintained by the Cloud Native Computing Foundation.
For more details, refer: [Kubernetes](https://kubernetes.io/)
### Kubernetes Node
A node is a worker machine in Kubernetes, previously known as a minion. A node may be a VM or physical machine, depending on the cluster. Each node contains the services necessary to run pods and is managed by the main components. The services on a node include the container runtime, kubelet and kube-proxy. 
For more details, refer: [Kubernetes Node](https://kubernetes.io/docs/concepts/architecture/nodes/)
### Kubernetes Storage Class
A storageclass in Kubernetes provides a way for administrators to describe the “classes” of storage they offer. Different classes might map to quality-of-service levels, or to backup policies, or to arbitrary policies determined by the cluster administrators.
For more details, refer: [Storage class](https://kubernetes.io/docs/concepts/storage/storage-classes/)
### Kubernetes PersistentVolume (PV)
A PersistentVolume (PV) is a piece of storage in the cluster that has been provisioned by an administrator or dynamically provisioned using Storage Classes. It is a resource in the cluster just like a node is a cluster resource. PV's are volume plugins like Volumes, but have a lifecycle independent of any individual pod that uses the PV.
For more details, refer: [PVC](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
### Kubernetes Persistent Volume Claim (PVC)
A PVC, binds a persistent volume to a pod that requested it. When a pod wants access to a persistent disk, it will request access to the claim which will specify the size , access mode and/or storage classes that it will need from a Persistent Volume.
For more details, refer: [PVC](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
### PGP signature
Pretty Good Privacy (PGP) is an encryption program that provides cryptographic privacy and authentication for data communication. PGP is used for signing, encrypting, and decrypting texts, e-mails, files, directories, and whole disk partitions.
For more details, refer: [PGP](https://en.wikipedia.org/wiki/Pretty_Good_Privacy)
### Playbook
An Ansible playbook is an organized unit of scripts that defines work for a server configuration managed by the automation tool Ansible.
For more details, refer: [Playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html)
### Pipeline
Jenkins Pipeline (or simply "Pipeline") is a suite of plugins which supports implementing and integrating continuous delivery pipelines into Jenkins. A continuous delivery pipeline is an automated expression of your process for getting software from version control right through to your users and customers.
For more details, refer: [Pipeline](https://jenkins.io/doc/book/pipeline/)
### Roles
Roles provide a framework for fully independent, or interdependent collections of variables, tasks, files, templates, and modules. In Ansible, the role is the primary mechanism for breaking a playbook into multiple files. This simplifies writing complex playbooks, and it makes them easier to reuse.
For more details, refer: [Roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)
### SCM
Supply Chain Management (SCM) is the broad range of activities required to plan, control and execute a product's flow, from acquiring raw materials and production through distribution to the final customer, in the most streamlined and cost-effective way possible.
### SHA256
SHA-256 stands for Secure Hash Algorithm – 256 bit and is a type of hash function commonly used in Blockchain. A hash function is a type of mathematical function which turns data into a fingerprint of that data called a hash. It’s like a formula or algorithm which takes the input data and turns it into an output of a fixed length, which represents the fingerprint of the data.
For more details, refer: [SHA256](https://en.bitcoinwiki.org/wiki/SHA-256)
### Sphinx
Sphinx is a tool that makes it easy to create intelligent and beautiful documentation, written by Georg Brandl and licensed under the BSD license. It was originally created for the Python documentation, and it has excellent facilities for the documentation of software projects in a range of languages.
For more details, refer: [Sphinx](https://www.sphinx-doc.org/)
### SSH
SSH, also known as Secure Shell or Secure Socket Shell, is a network protocol that gives users, particularly system administrators, a secure way to access a computer over an unsecured network. SSH also refers to the suite of utilities that implement the SSH protocol.
For more details, refer: [SSH](https://en.wikipedia.org/wiki/Secure_Shell)
### Template
* Ansible: A template in Ansible is a file which contains all your configuration parameters, but the dynamic values are given as variables. During the playbook execution, depending on the conditions like which cluster you are using, the variables will be replaced with the relevant values.
For more details, refer: [Ansible Template](https://docs.ansible.com/ansible/latest/modules/template_module.html)
* Helm Charts: In Helm Charts, Templates generate manifest files, which are YAML-formatted resource descriptions that Kubernetes can understand.
For more details, refer: [Helm Charts Template](https://helm.sh/docs/chart_template_guide/)
### TLS
Transport Layer Security, and its now-deprecated predecessor, Secure Sockets Layer, are cryptographic protocols designed to provide communications security over a computer network. 
For more details, refer: [TLS](https://en.wikipedia.org/wiki/Transport_Layer_Security)
### YAML
YAML ("YAML Ain't Markup Language") is a human-readable data-serialization language. It is commonly used for configuration files and in applications where data is being stored or transmitted. YAML targets many of the same communications applications as Extensible Markup Language but has a minimal syntax which intentionally differs from SGML.
For more details, refer: [YAML](https://en.wikipedia.org/wiki/YAML)


## Hyperledger-Fabric

This section lists specific terms used in Hyperledger Fabric

### CA
The Hyperledger Fabric CA is a Certificate Authority (CA) for Hyperledger Fabric. It provides features such as: registration of identities, or connects to LDAP as the user registry.
For more details, refer: [CA](https://hyperledger-fabric-ca.readthedocs.io/en/release-1.4/)

### CA Server
Fabric CA server is used to host one or more Certification Authorities (Fabric CA) for your Fabric Network (based on the MSPs)
### Chaincode
Chaincode is a piece of code that is written in one of the supported languages such as Go or Java. It is installed and instantiated through an SDK or CLI onto a network of Hyperledger Fabric peer nodes, enabling interaction with that network’s shared ledger.
For more details, refer: [Chaincode](https://hyperledger-fabric.readthedocs.io/en/release-1.4/chaincode.html)
### Channel
A Hyperledger Fabric channel is a private “subnet” of communication between two or more specific network members, for the purpose of conducting private and confidential transactions. A channel is defined by members (organizations), anchor peers per member, the shared ledger, chaincode application(s) and the ordering service node(s). 
For more details, refer: [Channel](https://hyperledger-fabric.readthedocs.io/en/release-1.4/channels.html)
### Channel Artifacts
Artifacts in Hyperledger are channel configuration files which are required for the Hyperledger Fabric network. They are generated at the time of network creation.
For more details, refer: [Channel Artifacts](https://hyperledger-fabric.readthedocs.io/en/release-1.4/channel_update_tutorial.html)
### Instantiate
Instantiating a chaincode means to initialize it with initial values.
For more details, refer: [Instantiating Chaincode](https://hyperledger-fabric.readthedocs.io/en/stable/install_instantiate.html)
### MSP
Hyperledger Fabric includes a Membership Service Provider (MSP) component to offer an abstraction of all cryptographic mechanisms and protocols behind issuing and validating certificates, and user authentication.
For more details, refer: [MSP](https://hyperledger-fabric.readthedocs.io/en/release-1.4/msp.html)
### Orderer
Orderer peer is considered as the central communication channel for the Hyperledger Fabric network. Orderer peer/node is responsible for consistent Ledger state across the network. Orderer peer creates the block and delivers that to all the peers
For more details, refer: [Orderer](https://hyperledger-fabric.readthedocs.io/en/release-1.4/orderer/ordering_service.html)
### Peer
Hyperledger Fabric is a permissioned blockchain network that gets set up by the organizations that intend to set up a consortium. The organizations that take part in building the Hyperledger Fabric network are called the "members." Each member organization in the blockchain network is responsible for setting up their peers to participate in the network. All of these peers need to be configured with appropriate cryptographic materials, like certificates of authority and other information.
For more details, refer: [Peer](https://hyperledger-fabric.readthedocs.io/en/release-1.4/peers/peers.html)
### Zkkafka
Kafka is primarily a distributed, horizontally-scalable, fault-tolerant, commit log. A commit log is basically a data structure that only appends. No modification or deletion is possible, which leads to no read/write locks, and the worst case complexity O(1). There can be multiple Kafka nodes in the blockchain network, with their corresponding Zookeeper ensemble.
For more details, refer:  [zkkafka](https://hyperledger-fabric.readthedocs.io/en/release-1.4/peers/peers.html)
### RAFT
RAFT is distributed crash Fault tolerance consensus algorithm which makes sure that in the event of failure, the system should be able to take a decision and process clients request. In technical term Raft is a consensus algorithm for managing a replicated log. Replicated log is a part of Replicated state machine.
For more details, refer: [raft](https://hyperledger-fabric.readthedocs.io/en/release-2.0/orderer/ordering_service.html#raft-concepts)

## R3 Corda

This section lists specific terms used in R3 Corda.

### Compatibility Zone
Every Corda node is part of a “zone” (also sometimes called a Corda network) that is permissioned. Production deployments require a secure certificate authority. We use the term “zone” to refer to a set of technically compatible nodes reachable over a TCP/IP network like the internet. The word “network” is used in Corda but can be ambiguous with the concept of a “business network”, which is usually more like a membership list or subset of nodes in a zone that have agreed to trade with each other. For more details, refer [Compatibility Zone](https://docs.corda.net/compatibility-zones.html).
### CorDapp
CorDapps (Corda Distributed Applications) are distributed applications that run on the Corda platform. The goal of a CorDapp is to allow nodes to reach agreement on updates to the ledger. They achieve this goal by defining flows that Corda node owners can invoke over RPC.
For more details, refer: [CorDapp](https://docs.corda.net/cordapp-overview.html)
### Corda Node
A Corda node is a JVM run-time environment with a unique identity on the network that hosts Corda services and CorDapps.For more details, refer [Corda Node](https://docs.corda.net/key-concepts-node.html).

### Corda Web Server
A simple web server is provided that embeds the Jetty servlet container. The Corda web server is not meant to be used for real, production-quality web apps. Instead, it shows one example of using Corda RPC in web apps to provide a REST API on top of the Corda native RPC mechanism.
### Doorman
The Doorman CA is a Certificate Authority R3 Corda. It is used for day-to-day key signing to reduce the risk of the root network CA private key being compromised. This is equivalent to an intermediate certificate in the web PKI. For more details, refer [Doorman](https://docs.corda.net/releases/M16-RC04/permissioning.html).
### NetworkMap
The Network Map Service accepts digitally signed documents describing network routing and identifying information from nodes, based on the participation certificates signed by the Identity Service, and makes this information available to all Corda Network nodes. For more details, refer [Networkmap](https://docs.corda.net/network-map.html).

### Notary
The Corda design separates correctness consensus from uniqueness consensus, and the latter is provided by one or more Notary Services. The Notary will digitally sign a transaction presented to it, provided no transaction referring to any of the same inputs has been previously signed by the Notary, and the transaction timestamp is within bounds.  
Business network operators and network participants may choose to enter into legal agreements which rely on the presence of such digital signatures when determining whether a transaction to which they are party, or upon the details of which they otherwise rely, is to be treated as ‘confirmed’ in accordance with the terms of the underlying agreement. For more details, refer [Corda Notaries](https://docs.corda.net/key-concepts-notaries.html).

## Hyperledger-Indy

This section lists specific terms used in Hyperledger-Indy.

### Admin DID
A decentralized identifier for Admin as defined by the DID Data Model and Generic Syntax specification.

###  Admin Seed
Seed can be any randomly chosen 32 byte value. There is no predefined format for the seed and it used to initializing keys. The seed used for Admin key is called an admin seed.

### Agency
 A service provider that hosts Cloud Agents and may provision Edge Agents on behalf of a Ledger’s Entities.

### Agent
A software program or process used by or acting on behalf of a Ledger’s Entity to interact with other Agents or, via a Ledger’s Client component, directly with the Ledger. Agents are of two types: Edge Agents run at the edge of the network on a local device, while Cloud Agents run remotely on a server or cloud hosting service. Agents typically have access to a Wallet in order to perform cryptographic operations on behalf of the Ledger’s Entity they represent.

### Dependent
An Individual who needs to depend on a Guardian to administer the Individual’s Ledger Identities. Under a Trust Framework, all Dependents may have the right to become Independents. Mutually exclusive with Independent.

### Developer
An Identity Owner that has legal accountability (in a scenario where there is a Trust Framework) for the functionality of an Agent, or for software that interacts with an Agent or the Ledger, to provide services to a Ledger Entity.

### DID
A decentralized identifier as defined by the DID Data Model and Generic Syntax specification. DIDs enable interoperable decentralized self-sovereign identity management. An Identity Record is associated with exactly one DID. A DID is associated with exactly one DDO.

### Domain Genesis
Domain genesis is a genesis file used to initialize the network and may populate network with some domain data.

### Endorser
Endorser has the required rights to write on a ledger. Endorser submits a transaction on behalf of the original author.

### Genesis Record
The first Identity Record written to the Ledger that describes a new Ledger Entity. For a Steward, the Genesis Record must be written by a Trustee. For an Independent Identity Owner, the Genesis Record must be written by a Trust Anchor. For a Dependent Identity Owner, the Genesis Record must be written by a Guardian.

### Identity
A set of Identity Records, Claims, and Proofs that describes a Ledger Entity. To protect privacy: a) an Identity Owner may have more than one Ledger Identity, and b) only the Identity Owner and the Relying Party(s) with whom an Identity is shared knows the specific set of Identity Records, Claims, and Proofs that comprise that particular Identity.

### Identity Owner
A Ledger Entity who can be held legally accountable. An Identity Owner must be either an Individual or an Organization. Identity owners can also be distinguished as Independent Identity Owner and Dependent Identity Owner based on the writer of the Genesis record, for an Independent Identity Owner the Genesis Record must be written by a Trust Anchor and in case of a Dependent Identity Owner the Genesis Record must be written by a Guardian.

### Identity Record
A transaction on the Ledger that describes a Ledger Entity. Every Identity Record is associated with exactly one DID. The registration of a DID is itself an Identity Record. Identity Records may include Public Keys, Service Endpoints, Claim Definitions, Public Claims, and Proofs. Identity Records are Public Data.

### Identity Role
Each identity has a specific role in Indy described by one of four roles in Indy. These roles are Trustee, Steward, Endorser and Network Monitor.

### Issuer Key
The special type of cryptographic key necessary for an Issuer to issue a Claim that supports Zero Knowledge Proofs.

### Ledger
The ledger in Indy is Indy-plenum based. Provides a simple, python-based, immutable, ordered log of transactions backed by a merkle tree. For more details, refer [Indy-plenum](https://github.com/hyperledger/indy-plenum/)

### NYM Transaction
NYM record is created for a specific user, Trust Anchor, Sovrin Stewards or trustee. The transaction can be used for creation of new DIDs, setting and Key Rotation of verification key, setting and changing of roles.

### Pairwise-Unique Identifier
A Pseudonym used in the context of only one digital relationship (Connection). See also Pseudonym and Verinym.

### Pool Genesis
Pool genesis is a genesis file used to initialize the network and may populate network with some pool data.

### Private Claim
A Claim that is sent by the Issuer to the Holder’s Agent to hold (and present to Relying Parties) as Private Data but which can be verified using Public Claims and Public Data. A Private Claim will typically use a Zero Knowledge Proof, however it may also use a Transparent Proof.

### Private Data
Data over which an Entity exerts access control. Private Data should not be stored on a Ledger even when encrypted. Mutually exclusive with Public Data.

### Private Key
The half of a cryptographic key pair designed to be kept as the Private Data of an Identity Owner. In elliptic curve cryptography, a Private Key is called a signing key.

### Prover
The Entity that issues a Zero Knowledge Proof from a Claim. The Prover is also the Holder of the Claim.

### Pseudonym
A Blinded Identifier used to maintain privacy in the context on an ongoing digital relationship (Connection).

### Steward
An Organization, within a Trust Framework, that operate a Node. A Steward must meet the Steward Qualifications and agree to the Steward Obligations defined in the a Trust Framework. All Stewards are automatically Trust Anchors.

### Trust Anchor
An Identity Owner who may serve as a starting point in a Web of Trust. A Trust Anchor has two unique privileges: 1) to add new Identity Owners to a Network, and 2) to issue Trust Anchor Invitations. A Trust Anchor must meet the Trust Anchor Qualifications and agree to the Trust Anchor Obligations defined in a Trust Framework. All Trustees and Stewards are automatically Trust Anchors.  

### Verinym
A DID authorized to be written to an Indy-powered Ledger by a Trust Anchor so that it is directly or indirectly associated with the Legal Identity of the Identity Owner. Mutually exclusive with Anonym.

### Wallet
A software module, and optionally an associated hardware module, for securely storing and accessing Private Keys, Master Secrets, and other sensitive cryptographic key material and optionally other Private Data used by an Entity on Indy. A Wallet may be either an Edge Wallet or a Cloud Wallet. In Indy infrastructure, a Wallet implements the emerging DKMS standards for interoperable decentralized cryptographic key management.

### Zero Knowledge Proof
A Proof that uses special cryptography and a Master Secret to permit selective disclosure of information in a set of Claims. A Zero Knowledge Proof proves that some or all of the data in a set of Claims is true without revealing any additional information, including the identity of the Prover. Mutually exclusive with Transparent Proof.

## Quorum

This section lists specific terms used in Quorum.

### Constellation
Haskell implementation of a general-purpose system for submitting information in a secure way. it is comparable to a network of MTA (Message Transfer Agents) where messages are encrypted with PGP. Contains Node ( Private transaction manager ) and the Enclave. 

### Enode
Enode is a url which identifies a node, it is generated using the node keys.

### Istanbul Tool
Istanbul tool is Istanbul binary compiled from the code repository. The tool is used to generate the configuration files required for setting up the Quorum network with IBFT consensus.

### Node Keys
Node keys consist of node private and node public keys. Those keys are required by the binaries provided by Quorum to boot the node and the network.

### Private Transactions
Private Transactions are those Transactions whose payload is only visible to the network participants whose public keys are specified in the privateFor parameter of the Transaction . privateFor can take multiple addresses in a comma separated list.

### Public Transactions
Public Transactions are those Transactions whose payload is visible to all participants of the same Quorum network. These are created as standard Ethereum Transactions in the usual way.

### Quorum Node
Quorum Node is designed to be a lightweight fork of geth in order that it can continue to take advantage of the R&D that is taking place within the ever growing Ethereum community. Quorum Node is running geth, a Go-Ethereum client with rpc endpoints. It supports raft and IBFT pluggable consensus and private and permissioned transactions.  

### State
Quorum supports dual state, Public State(accessible by all nodes within the network) and Private State(only accessible by nodes with the correct permissions). The difference is made through the use of transactions with encrypted (private) and non-encrypted payloads (public). Nodes can determine if a transaction is private by looking at the v value of the signature. Public transactions have a v value of 27 or 28, private transactions have a value of 37 or 38.

### Static nodes
Static nodes are nodes we keep referring to even if the node is not alive. so that when the nodes come alive, we can connect to them. Hostnames are permitted here and are resolved once at startup. If a static peer goes offline and its IP address changes, then it is expected that that peer will re-establish the connection in a fully static network or have discovery enabled.

### Tessera
Java implementation of a general-purpose system for submitting information in a secure way. It is comparable to a network of MTA (Message Transfer Agents) where messages are encrypted with PGP. Contains Node (private transaction manager) and The Enclave.

### The Enclave
Distributed ledger protocols typically leverage cryptographic techniques for transaction authenticity, participant authentication, and historical data preservation (i.e., through a chain of cryptographically hashed data). In order to achieve a separation of concerns as well as provide performance improvements through the parallelization of certain cryptographic operations, much of the cryptographic work, including symmetric key generation and data encryption and decryption, is delegated to the Enclave.

### Transaction Manager
Quorum’s Transaction Manager is responsible for transaction privacy. It stores and allows access to encrypted transaction data, exchanges encrypted payloads with other participants' transaction managers, but does not have access to any sensitive private keys. It utilizes the Enclave for cryptographic functionality (although the Enclave can optionally be hosted by the Transaction Manager itself).
