{{- define "labels.custom" -}}
  {{- range $key, $val := .Values.metadata.labels -}}
  {{- $key -}}: {{- $val -}}
  {{- end -}}
{{- end -}}
