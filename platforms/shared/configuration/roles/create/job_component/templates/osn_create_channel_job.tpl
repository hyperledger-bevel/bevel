global:
  version: {{ network.version }}
  serviceAccountName: vault-auth
  cluster:
    provider: {{ org.cloud_provider }}
    cloudNativeServices: false
  vault:
    type: hashicorp
    network: fabric
    address: {{ vault.url }}
    authPath: {{ network.env.type }}{{ name }}
    secretEngine: {{ vault.secret_path | default("secretsv2") }}
    secretPrefix: "data/{{ network.env.type }}{{ name }}"
    role: vault-role
    tls: false
  proxy:
    provider: {{ network.env.proxy | quote }}
    externalUrlSuffix: {{ org.external_url_suffix }}

image:
  fabricTools: {{ docker_url }}/{{ fabric_tools_image }}
  alpineUtils: {{ docker_url }}/bevel-alpine:{{ bevel_alpine_version }}
{% if network.docker.username is defined and network.docker.password is defined  %}
  pullSecret: regcred
{% else %}
  pullSecret: ""
{% endif %}

orderers:
{% for orderer in orderers_list %}
{% for key, value in orderer.items() %}
{% if key == 'name' %}
  - name: {{ value }}
    adminAddress: {{ value }}.{{ component_ns }}:7055
{% endif %}
{% if key == 'ordererAddress' %}
    ordererAddress: {{ value }}
{% endif %}
{% endfor %}
{% endfor %}

{% if add_orderer_value is defined and add_orderer_value %}
orderer:
  addOrderer: {{ add_orderer_value }}
  name: {{ first_orderer.name }}
  localMspId: {{ org.name | lower}}MSP
  ordererAddress: {{ existingOrdererAddress }}
{% endif %}
