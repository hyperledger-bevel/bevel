[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

Storageclass templates vary as per requirements and cloud provider specifications, this guide will help in adding and using a new storageclass in Hyperlegder Bevel.

Steps:

1. Add the storageclass provisioner as per cloud provider specifications, under `platforms/shared/charts/bevel-storageclass/templates/_helpers.tpl`.

    ```yaml
    --8<-- "platforms/shared/charts/bevel-storageclass/templates/_helpers.tpl:30:40"
    ```
    For example, storageclass for `cloud_provider_x` with required `provisioner_x` should be added as
    ```jinja
    ...
    {{- else if eq .Values.global.cluster.provider "cloud_provider_x" }}
    provisioner: provisioner_x
    ...
    ```

2. Update the `cloud_provider` enum under `platforms/network-schema.json` file with the new cloud provider name.
  For example, 
    ```json
    "cloud_provider": {
      "type": "string",
      "enum": [
        "aws",
        "aws-baremetal",
        "azure",
        "gcp",
        "minikube",
        "cloud_provider_x"
        ]}
    ```

3. Use the cloud provider in your network configuration file `cloud_provider` field under organization section.