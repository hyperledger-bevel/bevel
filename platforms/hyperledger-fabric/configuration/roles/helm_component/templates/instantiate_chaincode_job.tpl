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
      chart: {{ charts_dir }}/fabric-chaincode-instantiate
  values:
    metadata:
      namespace: {{ namespace }}
      images:
        fabrictools: {{ docker_url }}/{{ fabric_tools_image }}:{{ network.version }}
        alpineutils: {{ docker_url }}/bevel-alpine:latest
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
      lang: {{ component_chaincode.lang | default('golang') }}
      version: {{ component_chaincode.version }}
      instantiationarguments: {{ component_chaincode.arguments | quote}}
      endorsementpolicies:  {{ component_chaincode.endorsements | quote}}
    channel:
      name: {{ item.channel_name | lower }}