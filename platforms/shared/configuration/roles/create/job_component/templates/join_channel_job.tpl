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
  alpineUtils: {{ docker_url }}/bevel-alpine:{{ charts.bevel_alpine_version }}
  fabricTools: {{ docker_url }}/{{ charts.fabric_tools_image }}
{% if network.docker.username is defined and network.docker.password is defined  %}
  pullSecret: regcred
{% else %}
  pullSecret: ""
{% endif %}

peer:
  name: {{ peer_name }}
  type: {{ peer_type }}
{% if network.env.proxy == 'none' %}
  address: {{ peer.name }}.{{ component_ns }}:7051
{% else %}
  address: {{ peer.peerAddress }}
{% endif %}
  localMspId: {{ org.name | lower}}MSP
  logLevel: debug
  tlsStatus: true
  channelName: {{ channel_name }}  
  ordererAddress: {{ participant.ordererAddress }}
  addPeerValue: {{ add_peer_value }}
  addnewOrgValue: {{ add_new_org_value }}
