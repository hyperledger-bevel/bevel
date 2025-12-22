apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name | replace('_','-') }}
  namespace: {{ namespace }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  releaseName: {{ component_name | replace('_','-') }}
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/fabric-external-chaincode
  values:
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

    certs:
      refreshCertValue: false
      orgData:
{% if network.env.proxy == 'none' %}
        caAddress: ca.{{ namespace }}:7054
{% else %}
        caAddress: ca.{{ namespace }}.{{ org.external_url_suffix }}
{% endif %}
        caAdminUser: {{ name }}-admin
        caAdminPassword: {{ name }}-adminpw
        orgName: {{ name }}
        type: peer
        componentSubject: "{{ component_subject | quote }}"

    image:
      alpineUtils: {{ docker_url }}/bevel-alpine:latest
      catools:  {{ docker_url }}/bevel-fabric-ca:latest
      fabrictools:  {{ docker_url }}/bevel-fabric-tools
      external_chaincode:  {{ component_chaincode.image }}
{% if network.docker.username is defined and network.docker.password is defined  %}
      pullSecret: regcred
{% else %}
      pullSecret: ""
{% endif %}
    peer:
      name: {{ peer_name }}
      address: {{ peer_address }}
      localMspId: {{ name }}MSP
      logLevel: info
      tlsStatus: true

    chaincode:
      name: {{ component_chaincode.name }}
      version: {{ component_chaincode.version }}
      tls: {{ component_chaincode.tls }}
      crypto_mount_path: "/crypto"
{% if org.services.peers | length > 1 and peer_name != org.services.peers[0].name %}
      address: {{ org.services.peers[0].name }}-{{ component_chaincode.name }}-{{ chaincode.version | replace('.','-')}}.{{ namespace }}:7052
{% endif %}
      serviceType: ClusterIP
      port: 7052
      healthCheck: 
        retries: 20
        sleepTimeAfterError: 15
