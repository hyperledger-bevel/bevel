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
      chart: {{ charts_dir }}/fabric-chaincode-approve
  values:
    metadata:
      namespace: {{ namespace }}
      images:
        fabrictools: {{ docker_url }}/{{ fabric_tools_image[network.version] }}
        alpineutils: {{ docker_url }}/{{ alpine_image }}

    peer:
      name: {{ peer_name }}
      address: {{ peer_address }}
      localmspid: {{ name }}MSP
      loglevel: debug
      tlsstatus: true
    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ org.k8s.cluster_id | default('')}}{{ network.env.type }}{{ name }}
      adminsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ network.env.type }}{{ name }}/users/admin
      orderersecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ network.env.type }}{{ name }}/orderer
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
      version: {{ component_chaincode.version | default('1') }}
      sequence: {{ component_chaincode.sequence | default('1') }}
      lang: {{ component_chaincode.lang | default('golang') }}
      commitarguments: {{ component_chaincode.arguments | default('') | quote }}
      endorsementpolicies:  {{ component_chaincode.endorsements | default('') | quote }}
      initrequired: {{ component_chaincode.init_required | default('false') | quote }}
{% if component_chaincode.repository is defined %}
      repository:
        hostname: "{{ component_chaincode.repository.url.split('/')[0] | lower }}"
        git_username: "{{ component_chaincode.repository.username}}"
        url: {{ component_chaincode.repository.url }}
        branch: {{ component_chaincode.repository.branch }}
        path: {{ component_chaincode.repository.path }}
{% endif %}
{% if peer.chaincode.pdc is defined and peer.chaincode.pdc.enabled %}
      pdc:
        enabled: true
        collectionsconfig: "{{ lookup('file', '{{ peer.chaincode.pdc.collections_config }}') | b64encode }}"
{% else %}
      pdc:
        enabled: false
{% if component_chaincode.repository.collections_config is defined %}
        collectionsconfig:  {{ component_chaincode.repository.collections_config }} 
{% else %}
        collectionsconfig:  ""
{% endif %}
{% endif %}
    channel:
      name: {{ item.channel_name | lower }}
