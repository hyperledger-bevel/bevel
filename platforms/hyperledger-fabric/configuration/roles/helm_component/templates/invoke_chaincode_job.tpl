apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ namespace }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  releaseName: {{ component_name }}
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/fabric-chaincode-invoke
  values:
    metadata:
      namespace: {{ namespace }}
      network:
        version: {{ network.version }}
      add_organization: {{ add_organization }}
      images:
        fabricTools: {{ docker_url }}/{{ fabric_tools_image }}
        alpineUtils: {{ docker_url }}/bevel-alpine:{{ bevel_alpine_version }}

    peer:
      name: {{ peer_name }}
      address: {{ peer_address }}
      localmspid: {{ name }}MSP
      loglevel: debug
      tlsstatus: true
    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ org.k8s.cluster_id | default('')}}{{ network.env.type }}{{ org.name | lower }}
      secretpath: {{ vault.secret_path | default('secretsv2') }}
      adminsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}/peerOrganizations/{{ namespace }}/users/admin 
      orderersecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ org.name | lower }}/peerOrganizations/{{ namespace }}/orderer
      serviceaccountname: vault-auth
      type: {{ vault.type | default("hashicorp") }}
{% if network.docker.username is defined and network.docker.password is defined %}  
      imagesecretname: regcred
{% else %}
      imagesecretname: ""
{% endif %}
      tls: false
    orderer:
      address: {{ participant.ordererAddress }}
    chaincode:
      builder: hyperledger/fabric-ccenv:{{ network.version }}
      name: {{ component_chaincode.name | lower | e }}
      version: {{ component_chaincode.version }}
      invokearguments: {{ component_chaincode.arguments | default('') | quote }}
      endorsementpolicies:  {{ component_chaincode.endorsements | default('') | quote }}
    channel:
      name: {{ item.channel_name | lower }}
{% if '2.' in network.version %}
    endorsers:
      creator: {{ namespace }}
      name: {% for name in endorsers_list %}{%- for key, value in name.items() %}{% if key == 'name' %} {{ value }} {% endif %}{%- endfor %}{% endfor %}

      corepeeraddress: {% for address in endorsers_list %}{%- for key, value in address.items() %}{% if key == 'peercoreaddress' %} {{ value }} {% endif %}{% endfor -%}{% endfor %}

      nameslist: 
{% for name in endorsers_list %}
{% for key, value in name.items() %}
{% if key == 'name' %}
        - {{ key }}: {{ value }}
{% endif %}
{% endfor %}
{% endfor %}
{% else %}
    endorsers:
        creator: {{ namespace }}
        name: {{ peer_name }}
        corepeeraddress: {{ peer_address }}
{% endif %}
