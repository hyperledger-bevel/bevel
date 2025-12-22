# Bevel Sequence Diagram

When using Ansible automation in Bevel, it is important to understand the sequence and flow as this will determine how you configure your networking. 

!!! tip

    Do not use 127.0.0.1 or localhost to configure any services like Kubernetes or Vault.

``` mermaid
sequenceDiagram
    actor Operator
    Operator->>Controller: Run playbook
    Controller->>+Kubernetes Cluster: Configure Flux
    Kubernetes Cluster->>+ Git Repo: Check Authentication
    Git Repo-->>-Kubernetes Cluster: Success
    Kubernetes Cluster-->>-Controller: Flux configured
    loop Flux sync
        Git Repo->>Kubernetes Cluster: Create Helm releases
    end
    Controller->>Git Repo: Commit Helm Value files
    Kubernetes Cluster->>+Vault: Enable Kubernetes Authentication
    Vault-->>-Kubernetes Cluster: Authentication enabled
    Note right of Kubernetes Cluster: Kubernetes can now write/read from Vault
    Kubernetes Cluster->>Vault: Generate and store certificates
    Kubernetes Cluster->>+Kubernetes Cluster: Deploy Pods
    Kubernetes Cluster->>+Vault: Get certificates and secrets
    Vault-->>-Kubernetes Cluster: Certificates and secrets
    deactivate Kubernetes Cluster

```
