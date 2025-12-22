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
    authPath: {{ network.env.type }}{{ org.name | lower }}
    secretEngine: {{ vault.secret_path | default("secretsv2") }}
    secretPrefix: "data/{{ network.env.type }}{{ org.name | lower }}"
    role: vault-role
    tls: false

image:
  fabricTools: {{ docker_url }}/{{ fabric_tools_image }}
  alpineUtils: {{ docker_url }}/bevel-alpine:{{ bevel_alpine_version }}
{% if network.docker.username is defined and network.docker.password is defined %}
  pullSecret: regcred
{% else %}
  pullSecret: ""
{% endif %}

peerName: {{ peer.name }}
storageClass: {{ storage_class }}
storageSize: 256Mi
localMspId: {{ org.name | lower}}MSP
tlsStatus: true
ports:
  grpc:
    clusterIpPort: {{ peer.grpc.port }}
{% if orderer is defined %}
ordererAddress: {{ orderer.uri }}
{% elif participant is defined %}
ordererAddress: {{ participant.ordererAddress }}
{% endif %}

{% if network.env.labels is defined %}
labels:
{% if network.env.labels.service is defined %}
  service:
{% for key in network.env.labels.service.keys() %}
    - {{ key }}: {{ network.env.labels.service[key] | quote }}
{% endfor %}
{% endif %}
{% if network.env.labels.pvc is defined %}
  pvc:
{% for key in network.env.labels.pvc.keys() %}
    - {{ key }}: {{ network.env.labels.pvc[key] | quote }}
{% endfor %}
{% endif %}
{% if network.env.labels.deployment is defined %}
  deployment:
{% for key in network.env.labels.deployment.keys() %}
    - {{ key }}: {{ network.env.labels.deployment[key] | quote }}
{% endfor %}
{% endif %}
{% endif %}
