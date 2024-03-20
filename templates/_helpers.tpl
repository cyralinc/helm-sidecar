{{/*
Return the proper Cyral Sidecar image name
*/}}
{{- define "cyral.image" -}}
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
