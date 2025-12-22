{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fabric-external-chaincode.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fabric-external-chaincode.fullname" -}}
{{- $name := default .Chart.Name -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" $name .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fabric-external-chaincode.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Get the orderer TLS cacert ConfigMap name
Tries multiple possible names in order of preference
*/}}
{{- define "ordererConfigMap" -}}
{{- $namespace := .Release.Namespace -}}
{{- $kubectlCmd := printf "kubectl get configmap -n %s" $namespace -}}
{{- if (lookup "v1" "ConfigMap" $namespace "orderer-tls-cacert") -}}
orderer-tls-cacert
{{- else if (lookup "v1" "ConfigMap" $namespace "peer0-orderer-tls-cacert") -}}
peer0-orderer-tls-cacert
{{- else -}}
orderer-tls-cacert
{{- end -}}
{{- end -}}

{{- define "labels.deployment" -}}
{{- range $value := .Values.labels.deployment }}
{{ toYaml $value }}
{{- end }}
{{- end }}

{{- define "labels.service" -}}
{{- range $value := .Values.labels.service }}
{{ toYaml $value }}
{{- end }}
{{- end }}

{{- define "labels.pvc" -}}
{{- range $value := .Values.labels.pvc }}
{{ toYaml $value }}
{{- end }}
{{- end }}
