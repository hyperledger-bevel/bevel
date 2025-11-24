apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name }}
  namespace: {{ name | lower | e }}-net
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
      chart: {{ charts_dir }}/fabric-external-chaincode-install
  values:
    metadata:
      namespace: {{ namespace }}
      network:
        version: {{ network.version }}
      images:
        fabricTools: {{ docker_url }}/{{ charts.fabric_tools_image }}
        alpineUtils: {{ docker_url }}/bevel-alpine:{{ charts.bevel_alpine_version }}
    peer:
      name: {{ peer_name }}
      address: {{ peer_address }}
      localmspid: {{ name }}MSP
      loglevel: debug
      tlsstatus: true
    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ item.k8s.cluster_id | default('')}}{{ network.env.type }}{{ item.name | lower }}
      chaincodesecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ item.name | lower }}/peerOrganizations/{{ namespace }}/peers/{{ peer_name }}.{{ namespace }}/chaincodes
      adminsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ item.name | lower }}/peerOrganizations/{{ namespace }}/users/admin 
      orderersecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ item.name | lower }}/peerOrganizations/{{ namespace }}/orderer
      serviceaccountname: vault-auth
      type: {{ vault.type | default("hashicorp") }}
{% if network.docker.username is defined and network.docker.password is defined %}
      imagesecretname: regcred
{% else %}
      imagesecretname: ""
{% endif %}
      secretgitprivatekey: {{ vault.secret_path | default('secretsv2') }}/data/{{ item.name | lower }}/credentials/{{ namespace }}/git?git_password
      tls: false
      chaincodepackageprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ item.name | lower }}/peerOrganizations/{{ namespace }}/chaincodes/{{ component_chaincode.name | lower | e }}/package/v{{ component_chaincode.version }}
    chaincode:
      name: {{ component_chaincode.name | lower | e }}
      version: {{ component_chaincode.version }}
      tls: {{ component_chaincode.tls }}
      address: cc-{{ component_chaincode.name | lower | e }}.{{ namespace }}.svc.cluster.local:7052
