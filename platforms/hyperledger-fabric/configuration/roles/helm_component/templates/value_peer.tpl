apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: {{ component_name | replace('_','-') }}
  namespace: {{ component_ns }}
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
      chart: {{ charts_dir }}/fabric-peernode    
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

    storage:
      enabled: false
      nameOverride: {{ sc_name }}
      peer: 512Mi
      couchdb: 512Mi

    certs:
      generateCertificates: true
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
        componentSubject: "{{ component_subject }}"

{% if org.users is defined %}
      users: 
        usersList:
{% for user in user_list %}
        - {{ user }}
{% endfor %}
{% endif %}

      settings:
        createConfigMaps: {{ create_configmaps }}
        refreshCertValue: false
        addPeerValue: {{ add_peer_value }}
        removeCertsOnDelete: true
        removeOrdererTlsOnDelete: true

    image:
      couchdb: {{ docker_url }}/{{ couchdb_image }}
      peer: hyperledger/fabric-peer
      alpineUtils: {{ docker_url }}/bevel-alpine:{{ bevel_alpine_version }}
{% if network.docker.username is defined and network.docker.password is defined  %}
      pullSecret: regcred
{% else %}
      pullSecret: ""
{% endif %}

    peer:
      gossipPeerAddress: {{ peer.peerAddress }}
      logLevel: info
      localMspId: {{ name }}MSP
      tlsStatus: true
      cliEnabled: {{ enabled_cli }}
      storageClass: {{ sc_name }}
      ordererAddress: {{ orderer.uri }}
      builder: hyperledger/fabric-ccenv
      couchdb:
        username: {{ name }}-user
        password: {{ name }}-userpw
      mspConfig:
        organizationalUnitIdentifiers:
        nodeOUs:
          clientOUIdentifier: client
          peerOUIdentifier: peer
          adminOUIdentifier: admin
          ordererOUIdentifier: orderer
      serviceType: ClusterIP 
      loadBalancerType: ""
      ports:
        grpc:
          clusterIpPort: {{ peer.grpc.port }}
{% if peer.grpc.nodePort is defined %}
          nodePort: {{ peer.grpc.nodePort }}
{% endif %}
        events:
          clusterIpPort: {{ peer.events.port }}
{% if peer.events.nodePort is defined %}
          nodePort: {{ peer.events.nodePort }}
{% endif %}
        couchdb:
          clusterIpPort: {{ peer.couchdb.port }}
{% if peer.couchdb.nodePort is defined %}
          nodepnodePortort: {{ peer.couchdb.nodePort }}
{% endif %}
        metrics:
          enabled: {{ peer.metrics.enabled | default(false) }}
          clusterIpPort: {{ peer.metrics.port | default(9443) }}    
      resources:
        limits:
          memory: 1Gi
          cpu: 1
        requests:
          memory: 512M
          cpu: 0.25
      upgrade: {{ network.upgrade | default(false) }}
      healthCheck: 
        retries: 20
        sleepTimeAfterError: 15

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
