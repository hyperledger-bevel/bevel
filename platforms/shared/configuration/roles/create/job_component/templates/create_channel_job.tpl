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

peer:
  name: {{ peer_name }}
{% if provider == 'none' %}
  address: {{ peer_name }}.{{ component_ns }}:7051
{% else %}
  address: {{ peer_address }}
{% endif %}
  localMspId: {{ org.name | lower }}MSP
  logLevel: debug
  tlsStatus: true
  ordererAddress: {{ peer.ordererAddress }}
