# Bevel current roadmap

``` mermaid
timeline
    title Hyperledger Bevel 2024 Roadmap
    section 2024 Q1
        Helm charts on Helm repo 
            : All platforms
        Documentation Redesign 
            : Restructure 
            : Format Config & Ops required sections
        Github Actions 
            : All platforms
    section 2024 Q2
        Helm depencencies 
            : Besu
            : Corda 
            : Fabric
            : Quorum
    section 2024 Q3
        Helm depencencies 
            : Indy
            : Substrate
        AWS secrets as vault
    section 2024 Q4
        Deployment using Kubernetes Operator
            : Besu


```

OFE* : Operational feature enhancement

Legend of annotations:

| Icon                   | Description      |
|-----|----|
| :octicons-pin-16:                  | work to do       |
| :octicons-check-16:                 | work completed   |
| :material-run:                 | on-going work    |
| :octicons-trophy-16:                  | stretch goal     |
| :octicons-stop-16:                  | on hold          |

## Documentation
-  :material-run: Spell linting workflow for PR checks
-  :material-run: Format/Update configuration file and ops section
-  :material-run: Troubleshooting guide
-  :octicons-pin-16: deployment workflow guide

## General/Shared
- :material-run: Grafana and Promethus integration
- :material-run: Consistent variable names for helm chart values
- :material-run: Add default values to chart templates/values section
- :octicons-trophy-16:  Improve logging/error messaging in playbooks and log storage
- :octicons-trophy-16: Devcontainer for vscode containers/codespaces
- :octicons-trophy-16: Git commit/yaml linting
- :octicons-trophy-16: Support for additional vault, hashicorp alternatives
- :octicons-stop-16:   Setup AWS cloudwatch exporter

## Platforms

- R3 Corda Enterprise and open source
    - :octicons-stop-16:   HA Notary options
    - :octicons-stop-16:   Enable PostGreSQL support for Corda Enterprise
    - :octicons-stop-16:   Removal of node
    - :octicons-pin-16:   Cacti connector for Corda opensource
    - :octicons-pin-16: Deploy using just helm with no proxy, no vault option
    - :octicons-pin-16: Corda enterprise and opensource Node/Notary v4.11 support
    - :octicons-pin-16: Add cordapps operations and update docs
- R3 Corda OS v5
    - :octicons-stop-16: Base network deployment
- Hyperledger Fabric
    - :octicons-pin-16: Deploy using just helm with no proxy, no vault option
    - :octicons-pin-16: chaincode and channel mgmt. decoupled from network deployment
    - :octicons-pin-16: chaincode operations via operator console
    - :octicons-stop-16: chaincode operations automation using bevel-operator-fabric
    - :octicons-stop-16: CI/CD piplelines for chaincode deployment
- Hyperledger Besu
    - :octicons-stop-16:   Enable node discovery
    - :octicons-stop-16:   Enable bootnodes
    - :octicons-pin-16: Test promethus/Grafana chart for node monitoring data
    - :octicons-pin-16: Test tls cert creation using letsencrypt
    - :octicons-pin-16: Test onchain permission for Besu platform
    - :octicons-pin-16: Addition of new validator node and add guide for the same 
    - :octicons-pin-16: Besu node version upgrades
    - :octicons-check-16: Tessera version upgrades
    - :octicons-stop-16: Support for Besu node on public network
- Quorum
    - :octicons-pin-16: Deploy using just helm with no proxy, no vault option
    - :octicons-pin-16: Addition of new validator node and add guide for the same 
- Hyperledger Indy
    - :octicons-pin-16: Deploy using just helm with no proxy, no vault option
    - :octicons-pin-16:   Node version upgrades
    - :octicons-stop-16:  Removal of organizations from a running Indy Network
- Substrate
    - :octicons-pin-16: Deploy using just helm with no proxy, no vault option
    - :octicons-trophy-16:  Test with generic substrate node
    - :octicons-trophy-16:  Adding of org/new node

## Bevel Samples

-  :material-run: Upgrade Ambassador proxy to Edge stack
-  :material-run: Upgrade rest server/middleware applications
-  :octicons-pin-16: Test Hyperledger Aries contribution and see if can replace aca-py

## Bevel Kubernetes Operators

- Bevel-Operator-Fabric
    - :octicons-pin-16: Host helm charts to github hosted helm repo
    - :octicons-trophy-16:  Use bevel platforms fabric chart
- Operator Quorum 
    - :octicons-trophy-16:  Architecture diagram
- Operator Besu 
    - :octicons-stop-16:   Architecture diagram 
- Operator Corda
    - :octicons-stop-16:   Architecture diagram

## DevOps-Pipeline
- :octicons-pin-16: Chart testing
