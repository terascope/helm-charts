{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kafka.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kafka.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Generate the controller quorum bootstrap servers string
*/}}
{{- define "kafka.controllerQuorumBootstrapServers" -}}
{{- $context := . }}
{{- $servers := list }}
{{- range $i := until (int $context.Values.replicas) }}
    {{- $servers = append $servers (printf "%s-%d.%s-headless.%s.svc.%s:%d" (include "kafka.fullname" $context) $i (include "kafka.fullname" $context) $context.Release.Namespace  $context.Values.clusterDomain ( int $context.Values.headless.controller.port)) }}
{{- end }}
{{- join "," $servers }}
{{- end }}

{{/*
Generate the controller quorum voters string
*/}}
{{- define "kafka.controllerQuorumVoters" -}}
{{- $context := . }}
{{- $voters := list }}
{{- range $i := until (int $context.Values.replicas) }}
  {{- $voters = append $voters (printf "%d@%s-%d.%s-headless.%s.svc.%s:%d" $i (include "kafka.fullname" $context) $i (include "kafka.fullname" $context) $context.Release.Namespace  $context.Values.clusterDomain ( int $context.Values.headless.controller.port)) }}
{{- end }}
{{- join "," $voters }}
{{- end }}

{{/*
Default statefulset broker configuration settings
*/}}
{{- define "kafka.defaultBrokerConfigs" -}}
controller.listener.names: "CONTROLLER"
controller.quorum.bootstrap.servers: "{{ include "kafka.controllerQuorumBootstrapServers" . }}"
controller.quorum.voters: "{{ include "kafka.controllerQuorumVoters" . }}"
listeners: "PLAINTEXT://0.0.0.0:{{ .Values.headless.broker.plaintext.port }},CONTROLLER://0.0.0.0:{{ .Values.headless.controller.port }}"
listener.security.protocol.map: "PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT"
log.dirs: "{{ .Values.persistence.mountPath }}/{{ .Values.logSubPath }}"
process.roles: "broker,controller"
{{- end -}}

{{/*
Derive statefulset broker configuration settings in following priority order: configurationOverrides, kafka.defaultBrokerConfigs
*/}}
{{- define "kafka.brokerConfigs" -}}
{{- $defaultBrokerConfigs := fromYaml (include "kafka.defaultBrokerConfigs" .) -}}
{{- $brokerConfigs := merge .Values.configurationOverrides $defaultBrokerConfigs -}}
{{- toYaml $brokerConfigs -}}
{{- end -}}

{{/*
Derive offsets.topic.replication.factor in following priority order: configurationOverrides, replicas
*/}}
{{- define "kafka.replication.factor" }}
{{- $replicationFactorOverride := index .Values "configurationOverrides" "offsets.topic.replication.factor" }}
{{- default .Values.replicas $replicationFactorOverride }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kafka.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "kafka.chartName" -}}
{{- printf "%s" .Chart.Name | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{/*
Create unified labels for kafka components
*/}}

{{- define "kafka.common.matchLabels" -}}
app.kubernetes.io/name: {{ include "kafka.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "kafka.common.metaLabels" -}}
helm.sh/chart: {{ include "kafka.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "kafka.common.specLabels" -}}
helm.sh/chart: {{ include "kafka.chartName" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}


{{- define "kafka.broker.matchLabels" -}}
app.kubernetes.io/component: kafka-broker
{{ include "kafka.common.matchLabels" . }}
{{- end -}}

{{- define "kafka.broker.labels" -}}
{{ include "kafka.common.metaLabels" . }}
{{ include "kafka.broker.matchLabels" . }}
{{- end -}}

{{- define "kafka.broker.specLabels" -}}
{{ include "kafka.common.specLabels" . }}
{{ include "kafka.broker.matchLabels" . }}
{{- end -}}

{{- define "kafka.config.matchLabels" -}}
app.kubernetes.io/component: kafka-config
{{ include "kafka.common.matchLabels" . }}
{{- end -}}

{{- define "kafka.config.labels" -}}
{{ include "kafka.common.metaLabels" . }}
{{ include "kafka.config.matchLabels" . }}
{{- end -}}

{{- define "kafka.monitor.matchLabels" -}}
app.kubernetes.io/component: kafka-monitor
{{ include "kafka.common.matchLabels" . }}
{{- end -}}

{{- define "kafka.agent-monitor.matchLabels" -}}
app.kubernetes.io/component: kafka-agent-monitor
{{ include "kafka.common.matchLabels" . }}
{{- end -}}

{{- define "kafka.agent-monitor.labels" -}}
{{ include "kafka.common.metaLabels" . }}
{{ include "kafka.agent-monitor.matchLabels" . }}
{{- end -}}

{{- define "kafka.monitor.labels" -}}
{{ include "kafka.common.metaLabels" . }}
{{ include "kafka.monitor.matchLabels" . }}
{{- end -}}

{{- define "kafka.kafka-topic-usage-exporter.matchLabels" -}}
app.kubernetes.io/component: kafka-topic-usage-exporter
{{ include "kafka.common.matchLabels" . }}
{{- end -}}

{{- define "kafka.kafka-topic-usage-exporter.labels" -}}
{{ include "kafka.common.metaLabels" . }}
{{ include "kafka.kafka-topic-usage-exporter.matchLabels" . }}
{{- end -}}


{{- define "serviceMonitor.namespace" -}}
{{- if .Values.prometheus.operator.serviceMonitor.releaseNamespace -}}
{{ .Release.Namespace }}
{{- else -}}
{{ .Values.prometheus.operator.serviceMonitor.namespace }}
{{- end -}}
{{- end -}}

{{- define "prometheusRule.namespace" -}}
{{- if .Values.prometheus.operator.prometheusRule.releaseNamespace -}}
{{ .Release.Namespace }}
{{- else -}}
{{ .Values.prometheus.operator.prometheusRule.namespace }}
{{- end -}}
{{- end -}}
