{{/*
Copyright Cyral, Inc.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/*
Return the proper Cyral Sidecar image name
*/}}
{{- define "cyral.image" -}}
{{- if not .Values.image.tag -}}
    {{- fail "image.tag (e.g., sidecar version) is required" -}}
{{- end -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "cyral.imagePullSecrets" -}}
{{- include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "cyral.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return true if a secret for Cyral Sidecar credentials should be created
*/}}
{{- define "cyral.createCredentialsSecret" -}}
{{- if and (not .Values.cyral.credentials.existingSecret) .Values.cyral.credentials.clientId .Values.cyral.credentials.clientSecret -}}
  {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Get Cyral Sidecar credentials secret
*/}}
{{- define "cyral.credentials.secretName" -}}
{{- if (include "cyral.createCredentialsSecret" .) -}}
    {{- printf "%s-credentials-secret" (include "common.names.fullname" .) -}}
{{- else if not (empty .Values.cyral.credentials.existingSecret) -}}
    {{- tpl .Values.cyral.credentials.existingSecret $ -}}
{{- else -}}
    {{- fail "cyral.credentials.clientId and cyral.credentials.clientSecret are required if cyral.credentials.existingSecret is empty." -}}
{{- end -}}
{{- end -}}

{{/*
Get Cyral Sidecar TLS cert secret
*/}}
{{- define "cyral.certificates.tls.secretName" -}}
{{- if not .Values.cyral.sidecar.certificates.tls.existingSecret -}}
    {{- printf "%s-selfsigned-certificate" (include "common.names.fullname" .) -}}
{{- else -}}
    {{- tpl .Values.cyral.sidecar.certificates.tls.existingSecret $ -}}
{{- end -}}
{{- end -}}

{{/*
Get Cyral Sidecar CA cert secret
*/}}
{{- define "cyral.certificates.ca.secretName" -}}
{{- if not .Values.cyral.sidecar.certificates.ca.existingSecret -}}
    {{- printf "%s-ca-certificate" (include "common.names.fullname" .) -}}
{{- else -}}
    {{- tpl .Values.cyral.sidecar.certificates.ca.existingSecret $ -}}
{{- end -}}
{{- end -}}
