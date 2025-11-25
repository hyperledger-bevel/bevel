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
    global:
      version: {{ network.version }}
      serviceAccountName: vault-auth
      cluster:
        provider: {{ org.cloud_provider }}
        cloudNativeServices: false
      vault:
        type: hashicorp
        address: {{ vault.url }}
        role: vault-role
        authPath: {{ network.env.type }}{{ org_name }}
        secretEngine: {{ vault.secret_path | default("secretsv2") }}
        secretPrefix: "data/{{ network.env.type }}{{ org_name }}"
        tls: false
      proxy:
        provider: {{ network.env.proxy | quote }}
        externalUrlSuffix: {{ org.external_url_suffix }}

    metadata:
      namespace: {{ namespace }}
      network:
        version: {{ network.version }}
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
      peerschaincodetlssecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ network.env.type }}{{ org.name | lower }}/chaincodes/secrets
      adminsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ env_type }}{{ org.name | lower }}/users/admin
{% if network.docker.username is defined and network.docker.password is defined %}
      imagesecretname: regcred
{% else %}
      imagesecretname: ""
{% endif %}
      secretgitprivatekey: {{ vault.secret_path | default('secretsv2') }}/data/{{ env_type }}{{ org.name | lower }}/credentials/{{ namespace }}/git
      chaincodepackageprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ env_type }}{{ org.name | lower }}/chaincodes
    chaincode:
      name: {{ component_chaincode.name | lower | e }}
      version: {{ component_chaincode.version }}
      tls_disabled: {{ (not component_chaincode.tls) | lower }}
      address: cc-{{ component_chaincode.name | lower | e }}.{{ namespace }}.svc.cluster.local:7052

    certs:
      generateCertificates: {{ (component_chaincode.tls and install_count[component_chaincode.name] == 0) | lower }}
      orgData:
{% if network.env.proxy == 'none' %}
        caAddress: ca.{{ namespace }}:7054
{% else %}
        caAddress: ca.{{ namespace }}.{{ org.external_url_suffix }}
{% endif %}
        caAdminUser: {{ org_name }}-admin
        caAdminPassword: {{ org_name }}-adminpw
        orgName: {{ org_name }}
        type: chaincode
        componentSubject: "{{ component_subject | quote }}"
      users:
        usersList:
          - user:
            identity: peers-{{ component_chaincode.name | lower | e }}
            attributes:

      settings:
        createConfigMaps: false
        refreshCertValue: false
        addPeerValue: false
        removeCertsOnDelete: false
        removeOrdererTlsOnDelete: false