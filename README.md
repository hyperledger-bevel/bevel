# Hyperledger Bevel [![join the chat][chat-image]][chat-url]

[chat-url]: https://discord.gg/hyperledger
[chat-image]: https://img.shields.io/discord/905194001349627914?logo=Hyperledger&style=plastic.svg

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE) [![Documentation Status](https://readthedocs.org/projects/hyperledger-bevel/badge/?version=latest)](https://hyperledger-bevel.readthedocs.io/en/latest/?badge=latest) [![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3548/badge)](https://bestpractices.coreinfrastructure.org/projects/3548)
 [![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/hyperledger/bevel/badge)](https://scorecard.dev/viewer/?uri=github.com/hyperledger/bevel)
[![DCI Lint Status](https://github.com/hyperledger/bevel/actions/workflows/dci_lint.yml/badge.svg)](https://github.com/hyperledger/bevel/actions/workflows/dci_lint.yml)

- [Short Description](#short-description)
- [Scope of Project](#scope-of-project)
  - [Getting Started](#getting-started)
  - [Hyperledger Fabric](#hyperledger-fabric)
  - [Corda Enterprise](#corda-enterprise)
  - [Corda Opensource](#corda-opensource)
  - [Hyperledger Indy](#hyperledger-indy)
  - [Quorum](#quorum)
  - [Hyperledger Besu](#hyperledger-besu)
  - [Substrate](#substrate)
- [Contact](#contact)
- [Contributing](#contributing)
- [Build Image](#build)
- [Initial Committers](#initial-committers)
- [Sponsor](#sponsor)

## Short Description
An automation framework and helm charts for rapidly and consistently deploying production-ready Distributed Ledger Technology (DLT) platforms.

## Scope of Project
Hyperledger Bevel is an automation framework for rapidly and consistently deploying production-ready DLT platforms to cloud infrastructure.

![What is Hyperledger Bevel?](./docs/images/hyperledger-bevel-overview.png "What is Hyperledger Bevel?")

Hyperledger Bevel is an accelerator/tool that helps developers rapidly set up and deploy secure, scalable and production-ready DLT network(s) that also allows new organizations to be easily on-boarded on the network. Bevel facilitates a safe and secure way of deploying and operating different DLT platforms.

It includes: 
- Helm charts to **deploy** different DLT nodes and to generate the related crypto/identities. 
- Helm charts for various **operational features** like adding new nodes, and deploying smart contracts.
- Helm charts to deploy Hyperledger **Cacti connectors** for Fabric, Quorum and Besu networks. 
- **Ansible playbooks** and modular role definitions to automate the deployment of Helm charts.
- Ansible playbooks and roles to automate deployment of Hyperledger fabric using  **bevel-operator-fabric** (Kubernetes operator for managing Hyperledger Fabric networks).
- Integrated CD using **GitOps** so that once the network is set up, all changes can be done via git PRs/merges.
- Configuration for Ambassador Edge Stack, HAProxy (for Hyperledger Fabric) and Istio Ingress (for Substrate) to act as Ingress Controller. 

Hyperledger Bevel currently supports R3 Corda OS and Enterprise, Hyperledger Fabric, Hyperledger Indy, Hyperledger Besu, Quorum and Substrate. Other DLT platforms can easily be added.

## Getting Started

To get started with the framework quickly, follow our [Getting Started guidelines](https://hyperledger-bevel.readthedocs.io/en/latest/getting-started/prerequisites/).

Detailed operator and developer documentation is available on [our ReadTheDocs site](https://hyperledger-bevel.readthedocs.io/en/latest/index.html).

The documentation can also be built locally be following instructions in the `docs` folder.

## Hyperledger Fabric
For Hyperledger Fabric, there are two ways to deploy the network.

- Using `helm install`: Follow the [Fabric Charts readme](./platforms/hyperledger-fabric/charts/README.md).
- Using Ansible: A number of different Ansible scripts will allow you to either create a new network (across clouds) or join an existing network.

  ![Hyperledger Bevel - Fabric](./docs/images/hyperledger-bevel-fabric.png "Hyperledger Bevel for Hyperledger Fabric")

## Corda Enterprise
For Corda Enterprise, there are two ways to deploy the network.

- Using `helm install`: Follow the [Corda Enterprise Charts readme](./platforms/r3-corda-ent/charts/README.md).
- Using Ansible: A number of different Ansible scripts will allow you to either create a new network (across clouds) or join an existing network.

  ![Hyperledger Bevel - Corda Enterprise](./docs/images/hyperledger-bevel-corda-ent.png "Hyperledger Bevel for Corda Enterprise")

## Corda Opensource
For Corda Opensource, there are two ways to deploy the network.

-  Using `helm install`: Follow the [Corda Charts readme](./platforms/r3-corda/charts/README.md).
- Using Ansible: A number of different Ansible scripts will allow you to either create a new network (across clouds) or join an existing network.

  ![Hyperledger Bevel - Corda](./docs/images/hyperledger-bevel-corda.png "Hyperledger Bevel for Corda")

## Hyperledger Indy
For Hyperledger Indy, there are two ways to deploy the network.

- Using `helm install`: Follow the [Indy Charts readme](./platforms/hyperledger-indy/charts/README.md).
- Using Ansible: A number of different Ansible scripts will allow you to create a new network (across clouds).

![Hyperledger Bevel - Indy](./docs/images/hyperledger-bevel-indy.png "Hyperledger Bevel for Hyperledger Indy")

## Quorum
For Quorum, there are two ways to deploy the network.

- Using `helm install`: Follow the [Quorum Charts readme](./platforms/quorum/charts/README.md).
- Using Ansible: A number of different Ansible scripts will allow you to either create a new network (across clouds) with choice of Consensus and a transaction Manager.

  ![Hyperledger Bevel - Quorum](./docs/images/hyperledger-bevel-quorum.png "Hyperledger Bevel for Quorum")

## Hyperledger Besu
For Hyperledger Besu, there are two ways to deploy the network.

- Using `helm install`: Follow the [Besu Charts readme](./platforms/hyperledger-besu/charts/README.md).
- Using Ansible: A number of different Ansible scripts will allow you to create a new network (across clouds).

  ![Hyperledger Bevel - Besu](./docs/images/hyperledger-bevel-besu.png "Hyperledger Bevel for Hyperledger Besu")

## Substrate
For Substrate, there are two ways to deploy the network.

- Using `helm install`: Follow the [Substrate Charts readme](./platforms/substrate/charts/README.md).
- Using Ansible: A number of different Ansible scripts will allow you to create a new network (across clouds).

  ![Hyperledger Bevel - Substrate](./docs/images/hyperledger-bevel-substrate.png "Hyperledger Bevel for Substrate")

## Contact
We welcome your questions & feedback on our [Discord channel](https://discord.com/channels/905194001349627914/941739691336679454). [Please join our Discord first](https://discord.gg/hyperledger).

## Contributing
We welcome contributions to Hyperledger Bevel in many forms, and there’s always plenty to do!

Please review [contributing](./CONTRIBUTING.md) guidelines to get started.

## Build
If you are not using the provided Jenkins automation scripts, you can run the provisioning scripts within a docker runtime independent of your target Kubernetes cluster.
```
# Build provisioning image
docker build . -t ghcr.io/hyperledger/bevel-build

# Run the provisioning scripts
docker run -it -v $(pwd):/home/bevel/ ghcr.io/hyperledger/bevel-build
```

## Initial Committers
- [tkuhrt](https://github.com/tkuhrt)
- [jonathan-m-hamilton](https://github.com/jonathan-m-hamilton)
- [sownak](https://github.com/sownak)


## Sponsor
Mark Wagner (Github: [n1zyz](https://github.com/n1zyz), email: [mwagner@redhat.com](mailto:mwagner@redhat.com)) - TSC Member
