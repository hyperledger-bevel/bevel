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
  fabrictools: {{ docker_url }}/bevel-fabric-tools
  alpineUtils: {{ docker_url }}/bevel-alpine:latest
{% if network.docker.username is defined and network.docker.password is defined  %}
  pullSecret: regcred
{% else %}
  pullSecret: ""
{% endif %}

peer:
  name: {{ peer_name }}
{% if network.env.proxy == 'none' %}
  address: {{ peer_name }}.{{ component_ns }}:7051
{% else %}
  address: {{ peer_address }}
{% endif %}
  localMspId: {{ name }}MSP
  logLevel: info
  tlsStatus: true
  ordererAddress: {{ participant.ordererAddress }}

chaincode:
  channel: {{ item.channel_name }}
  name: {{ chaincode.name }}
  version: {{ chaincode.version | quote }}
  sequence: {{ chaincode.sequence | quote }}
  arguments: {{ chaincode.arguments }}
  endorsementPolicies: {{ chaincode.endorsements }}
  builder: hyperledger/fabric-ccenv:{{ network.version }}
  initRequired: {{ chaincode.init_required }}
{% if chaincode.collections_config is defined %}
  pdc:
    enabled: true
    collectionsConfig: {{ pdc_config_content }}
{% endif %}

# Endorsers configuration (for commit operation)
endorsers:
{% for endorser in endorsers_list %}
  - name: {{ endorser.name }}
    corePeerAddress: {{ endorser.corepeerAddress }}
    certificate: "{{ lookup('file',  endorser.certificate ) | b64encode }}"
{% endfor %}

# Lifecycle configuration
# Control which operations to perform
lifecycle:
  approve:
    enabled: true
    waitForInstall: true
{% if participant.type == 'creator' %}
  commit:
    enabled: true
    waitForApprove: true
  invoke:
    enabled: true
    waitForCommit: true
{% endif %}
