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
  alpineUtils: {{ docker_url }}/bevel-alpine:{{ bevel_alpine_version }}
  fabricTools: {{ docker_url }}/{{ fabric_tools_image }}
{% if network.docker.username is defined and network.docker.password is defined  %}
  pullSecret: regcred
{% else %}
  pullSecret: ""
{% endif %}

organizations:
{% for organization in network.organizations %}
{% for data, value in organization.items() %}
{% if data == 'name' %}
  - name: {{ value }}
{% endif %}
{% endfor %}
{% for service in organization.services %}
{% if service == 'orderers' %}
    orderers:
{% for orderer in organization.services.orderers %}
{% for key, value in orderer.items() %}
{% if key == 'name' %}
    - name: {{ value }}
{% endif %}
{% if key == 'ordererAddress' %}
      ordererAddress: {{ value }}
{% endif %}
{% endfor %}
{% endfor %}
{% endif %}
{% if service == 'peers' %}
    peers:
{% for peer in organization.services.peers %}
{% for key, value in peer.items() %}
{% if key == 'name' %}
    - name: {{ value }}
{% endif %}
{% if key == 'peerAddress' %}
      peerAddress: {{ value }}
{% endif %}
{% endfor %}
{% endfor %}
{% endif %}
{% endfor %}
{% endfor %}

consensus: {{ consensus }}

channels:
{% for channel in network.channels %} 
{% if channel.channel_status == 'new' %} 
  - name: {{ channel.channel_name | lower }}
    consortium: {{ channel.consortium }}
    orderers: 
{% for ordererOrg in channel.orderers %}
      - {{ ordererOrg }}
{% endfor %}
    participants:
{% for participant in channel.participants %}
      - {{ participant.name | lower }}
{% endfor %}
{% endif %}
{% endfor %}

settings:
  generateGenesis: {{ generateGenesis }} 
  removeConfigMapOnDelete: false

{% if add_org %}
add_new_org: {{ add_org }}
newOrgs:
{% for organization in network.organizations %}
{% for data, value in organization.items() %}
{% if data == 'name' and  organization.org_status == 'new' %}
  - name: {{ value }}
{% endif %}
{% endfor %}
{% endfor %}
{% endif %}
