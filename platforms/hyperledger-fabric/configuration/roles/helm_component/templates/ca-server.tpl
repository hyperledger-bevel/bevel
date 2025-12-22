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
      chart: {{ charts_dir }}/fabric-ca-server   
  values:
    global:
      serviceAccountName: vault-auth
      cluster:
        provider: {{ org.cloud_provider }}
        cloudNativeServices: false
        kubernetesUrl: {{ kubernetes_url }}
      vault:
        type: hashicorp
        network: fabric
        address: {{ vault.url }}
        authPath: {{ network.env.type }}{{ component }}
        secretEngine: {{ vault.secret_path | default("secretsv2") }}
        secretPrefix: "data/{{ network.env.type }}{{ component }}"
        role: vault-role
        tls: false
      proxy:
        provider: {{ network.env.proxy | quote }}
        externalUrlSuffix: {{ org.external_url_suffix }}

    storage:
      enabled: false
      nameOverride: {{ sc_name }}
      size: 512Mi

    image:
      alpineUtils: {{ docker_url }}/bevel-alpine:{{ bevel_alpine_version }}
      ca: {{ docker_url }}/{{ ca_image[network.version] }}
{% if network.docker.username is defined and network.docker.password is defined  %}
      pullSecret: regcred
{% else %}
      pullSecret: ""
{% endif %}

    server:
      removeCertsOnDelete: true
      tlsStatus: true
      adminUsername: {{ component }}-admin
      adminPassword: {{ component }}-adminpw
      subject: "{{ subject | quote }}"
{% if component_services.ca.configpath is defined %}
      configPath: conf/fabric-ca-server-config-{{ component }}.yaml
{% endif %}
{% if component_services.ca.grpc.nodePort is defined %}
      nodePort: {{ component_services.ca.grpc.nodePort }}
{% endif %}
      clusterIpPort: {{ component_services.ca.grpc.port }}

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
