apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: cc-{{ chaincode_name }}
  namespace: {{ chaincode_ns }}
  annotations:
    fluxcd.io/automated: "false"
spec:
  interval: 1m
  releaseName: cc-{{ chaincode_name }}
  chart:
    spec:
      interval: 1m
      sourceRef:
        kind: GitRepository
        name: flux-{{ network.env.type }}
        namespace: flux-{{ network.env.type }}
      chart: {{ charts_dir }}/fabric-external-chaincode  
  values:
    metadata:
      namespace: {{ chaincode_ns }}
      network:
        version: {{ network.version }}
      images:
        external_chaincode: {{ chaincode_image }}
        alpineutils: {{ docker_url }}/bevel-alpine:latest

    chaincode:
      name: {{ chaincode.name }}
      version: {{ chaincode.version }}
      ccid: {{ ccid.stdout | replace(',','') }} 
      tls: {{ chaincode.tls }}
{% if chaincode.tls == true %}      
      crypto_mount_path: {{ chaincode.crypto_mount_path }}
{% endif %}

    vault:
      role: vault-role
      address: {{ vault.url }}
      authpath: {{ item.k8s.cluster_id | default('')}}{{ network.env.type }}{{ item.name | lower }}
      chaincodesecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/{{ item.name | lower }}/peerOrganizations/{{ namespace }}/chaincodes/{{ chaincode.name }}/certificate/v{{ chaincode.version }}
      serviceaccountname: vault-auth
      type: {{ vault.type | default("hashicorp") }}
{% if chaincode.private_registry is not defined or chaincode.private_registry == false %}   
      imagesecretname: regcred
{% endif %}
{% if chaincode.private_registry is defined and chaincode.private_registry == true %}   
      imagesecretname: chaincode-private-regcred
{% endif %}
    service:
      servicetype: ClusterIP

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
