{{/*
Expand the name of the chart.
*/}}
{{- define "node.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "node.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" | lower }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride | lower }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" | lower }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" | lower }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "node.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" | lower }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "node.labels" -}}
helm.sh/chart: {{ include "node.chart" . }}
{{ include "node.selectorLabels" . }}
{{ include "node.serviceLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "node.selectorLabels" -}}
name: {{ include "node.name" . }}
app.kubernetes.io/name: {{ include "node.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Service labels
*/}}
{{- define "node.serviceLabels" -}}
{{- if .Values.node.chain }}
chain: {{ .Values.node.chain }}
{{- end }}
release: {{ .Release.Name }}
role: {{ .Values.node.role }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "node.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "node.fullname" .) .Values.global.serviceAccountName | lower }}
{{- else }}
{{- default "default" .Values.global.serviceAccountName | lower }}
{{- end }}
{{- end }}

{{/*
Template the logic for serviceType
*/}}
{{- define "node.serviceType" -}}
{{- if eq $.Values.node.perNodeServices.p2pServiceType "NodePort" }}
type: NodePort
externalTrafficPolicy: Local
{{- else if eq $.Values.node.perNodeServices.p2pServiceType "LoadBalancer" }}
type: LoadBalancer
{{- else if eq $.Values.node.perNodeServices.p2pServiceType "ClusterIP" }}
type: ClusterIP
{{- else }}
{{- fail "node.perNodeServices.p2pServiceType must one of type ClusterIP, LoadBalancer or NodePort" }}
{{- end }}
{{- end }}
