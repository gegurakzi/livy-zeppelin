{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "zeppelin-fullname" -}}
{{- $name := default .Chart.Name .Values.Zeppelin.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the apiVersion of deployment.
*/}}
{{- define "deployment.apiVersion" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "apps/v1" -}}
{{- end -}}
{{- end -}}

{{- define "livy.fullname" -}}
{{- $name := default .Chart.Name .Values.Livy.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "livy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "livy.serviceAccountName" -}}
{{- if .Values.Livy.ServiceAccount.Create -}}
    {{ default (include "livy.fullname" .) .Values.Livy.ServiceAccount.Name }}
{{- else -}}
    {{ default "default" .Values.Livy.ServiceAccount.Name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use by Spark Driver Pods
*/}}
{{- define "livy.sparkServiceAccountName" -}}
{{- if .Values.Livy.SparkServiceAccount.Create -}}
    {{ default (printf "%s-%s" (include "livy.fullname" .) "spark") .Values.Livy.SparkServiceAccount.Name }}
{{- else -}}
    {{ default "default" .Values.Livy.SparkServiceAccount.Name }}
{{- end -}}
{{- end -}}


