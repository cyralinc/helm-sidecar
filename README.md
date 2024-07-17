<!--- app-name: %%CHART_NAME%% -->

# Cyral Sidecar

## TL;DR

```console
helm install cyral-sidecar oci://public.ecr.aws/cyral/helm/sidecar
```

## Introduction

Helm chart to deploy Cyral Sidecar.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `cyral-sidecar`:

```console
helm install cyral-sidecar oci://REGISTRY_NAME/REPOSITORY_NAME/%%CHART_NAME%%
```

> Note: You need to substitute the placeholders `REGISTRY_NAME` and `REPOSITORY_NAME` with a reference to your Helm chart registry and repository. For example, in the case of Cyral, you need to use `REGISTRY_NAME=cyralinc.docker.io` and `REPOSITORY_NAME=cyralcharts`.

The command deploys Cyral Sidecar on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `cyral-sidecar` deployment:

```console
helm delete cyral-sidecar
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |

### Common parameters

| Name                | Description                                                                                                       | Value           |
| ------------------- | ----------------------------------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                                              | `""`            |
| `nameOverride`      | String to partially override common.names.fullname template with a string (will prepend the release name)         | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname template with a string                                             | `""`            |
| `commonAnnotations` | Common annotations to add to all Cyral Sidecar resources (sub-charts are not considered). Evaluated as a template | `{}`            |
| `commonLabels`      | Common labels to add to all Cyral Sidecar resources (sub-charts are not considered). Evaluated as a template      | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain                                                                                         | `cluster.local` |

### Cyral Sidecar deployment parameters

| Name                        | Description                                                                                                   | Value                  |
| --------------------------- | ------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                      | `hard`                 |
| `podAffinityPreset`         | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                           | `""`                   |
| `nodeAffinityPreset.type`   | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                     | `""`                   |
| `nodeAffinityPreset.key`    | Node label key to match Ignored if `affinity` is set.                                                         | `""`                   |
| `nodeAffinityPreset.values` | Node label values to match. Ignored if `affinity` is set.                                                     | `[]`                   |
| `affinity`                  | Affinity for pod assignment                                                                                   | `{}`                   |
| `image.registry`            | Cyral Sidecar image registry                                                                                  | `public.ecr.aws/cyral` |
| `image.repository`          | Cyral Sidecar image repository                                                                                | `cyral-sidecar`        |
| `image.digest`              | Cyral Sidecar image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                   |
| `image.pullPolicy`          | Cyral Sidecar image pull policy                                                                               | `IfNotPresent`         |
| `image.pullSecrets`         | Cyral Sidecar image pull secrets                                                                              | `[]`                   |
| `image.debug`               | Enable image debug mode                                                                                       | `false`                |
| `replicaCount`              | Number of Cyral Sidecar replicas to deploy                                                                    | `1`                    |
| `extraEnvVars`              | Extra environment variables to be set on Cyral Sidecar containers                                             | `[]`                   |
| `extraEnvVarsCM`            | ConfigMap with extra environment variables                                                                    | `""`                   |
| `extraEnvVarsSecret`        | Secret with extra environment variables                                                                       | `""`                   |

### Cyral Sidecar deployment parameters

| Name                                                | Description                                                                                                                      | Value            |
| --------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| `resources`                                         | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                | `{}`             |
| `nodeSelector`                                      | Node labels for pod assignment. Evaluated as a template.                                                                         | `{}`             |
| `tolerations`                                       | Tolerations for pod assignment. Evaluated as a template.                                                                         | `[]`             |
| `extraVolumes`                                      | Array of extra volumes to be added to the Cyral Sidecar deployment (evaluated as template). Requires setting `extraVolumeMounts` | `[]`             |
| `serviceAccount.create`                             | Enable creation of ServiceAccount for Cyral Sidecar pod                                                                          | `true`           |
| `serviceAccount.name`                               | The name of the ServiceAccount to use.                                                                                           | `""`             |
| `serviceAccount.annotations`                        | Annotations for service account. Evaluated as a template.                                                                        | `{}`             |
| `serviceAccount.automountServiceAccountToken`       | Auto-mount the service account token in the pod                                                                                  | `true`           |
| `rbac.create`                                       | Create Role and RoleBinding                                                                                                      | `true`           |
| `rbac.rules`                                        | Custom RBAC rules to set                                                                                                         | `[]`             |
| `podSecurityContext.enabled`                        | Enabled Cyral Sidecar pods' Security Context                                                                                     | `false`          |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                                                                                               | `Always`         |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface                                                                                   | `[]`             |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                                                                                                      | `[]`             |
| `podSecurityContext.fsGroup`                        | Set Cyral Sidecar pod's Security Context fsGroup                                                                                 | `1001`           |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                                                                                             | `false`          |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                                                                                                 | `nil`            |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                                                                                       | `1001`           |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot                                                                                    | `true`           |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged                                                                                      | `false`          |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem                                                                          | `false`          |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation                                                                        | `false`          |
| `containerSecurityContext.capabilities.drop`        | List of capabilities to be dropped                                                                                               | `["ALL"]`        |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile                                                                                 | `RuntimeDefault` |
| `containerPorts`                                    | Map of all ports inside Cyral Sidecar container                                                                                  | `{}`             |
| `extraContainerPorts`                               | Array of additional container ports for the Cyral Sidecar container                                                              | `[]`             |
| `service.type`                                      | Service type                                                                                                                     | `LoadBalancer`   |
| `service.ports`                                     | Map of Cyral Sidecar service ports                                                                                               | `{}`             |
| `service.nodePorts`                                 | Specify the nodePort(s) value(s) for the LoadBalancer and NodePort service types.                                                | `{}`             |
| `service.targetPort`                                | Target port reference value for the Loadbalancer service types can be specified explicitly.                                      | `{}`             |
| `service.clusterIP`                                 | Cyral Sidecar service Cluster IP                                                                                                 | `""`             |
| `service.loadBalancerIP`                            | LoadBalancer service IP address                                                                                                  | `""`             |
| `service.loadBalancerSourceRanges`                  | Cyral Sidecar service Load Balancer sources                                                                                      | `[]`             |
| `service.loadBalancerClass`                         | service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)                                         | `""`             |
| `service.sessionAffinity`                           | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                                                             | `None`           |
| `service.sessionAffinityConfig`                     | Additional settings for the sessionAffinity                                                                                      | `{}`             |
| `service.annotations`                               | Service annotations                                                                                                              | `{}`             |
| `service.externalTrafficPolicy`                     | Enable client source IP preservation                                                                                             | `Cluster`        |

### Cyral configuration parameters

| Name                                            | Description                                                                                                                                                                                    | Value             |
| ----------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- |
| `cyral.sidecarId`                               | Sidecar identifier                                                                                                                                                                             | `""`              |
| `cyral.controlPlane`                            | Address of the control plane - <tenant>.cyral.com                                                                                                                                              | `""`              |
| `cyral.credentials.existingSecret`              | Name of an existing Kubernetes secret containing client ID and client secret. The secret must contain the `clientId` and `clientSecret` keys.                                                  | `""`              |
| `cyral.credentials.clientId`                    | The client ID assigned to the sidecar. Optional - required only if existingSecret is not provided.                                                                                             | `""`              |
| `cyral.credentials.clientSecret`                | The client secret assigned to the sidecar. Optional - required only if existingSecret is not provided.                                                                                         | `""`              |
| `cyral.sidecar.dnsName`                         | Fully qualified domain name that will be used to access the Cyral Sidecar                                                                                                                      | `""`              |
| `cyral.sidecar.certificates.tls.existingSecret` | Name of an existing Kubernetes secret containing a private key and a certificate to terminate TLS connections.                                                                                 | `""`              |
| `cyral.sidecar.certificates.ca.existingSecret`  | Name of an existing Kubernetes secret containing a private key and a certificate for the internal CA.                                                                                          | `""`              |
| `cyral.sidecar.snowflake.SSOLoginURL`           | The IdP SSO URL for the IdP being used with Snowflake.                                                                                                                                         | `""`              |
| `cyral.sidecar.snowflake.idpCertificate`        | The certificate used to verify SAML assertions from the IdP being used with Snowflake. Enter this value as a one-line string with literal new line characters (\n) specifying the line breaks. | `""`              |
| `cyral.sidecar.snowflake.sidecarIdpCertificate` | The public certificate used to verify signatures for SAML Assertions generated by the sidecar. Required if using SSO with Snowflake.                                                           | `""`              |
| `cyral.sidecar.snowflake.sidecarIdpPrivateKey`  | The private key used to sign SAML Assertions generated by the sidecar. Required if using SSO with Snowflake.                                                                                   | `""`              |
| `cyral.deploymentProperties.cloud`              | Cloud provider where the Cyral Sidecar is hosted.                                                                                                                                              | `""`              |
| `cyral.deploymentProperties.endpoint`           | Fully qualified domain name that will be used to access the Cyral Sidecar.                                                                                                                     | `""`              |
| `cyral.deploymentProperties.deploymentType`     | Deployment type choosen to deploy the Cyral Sidecar. Defaults to `helm-kubernetes`.                                                                                                            | `helm-kubernetes` |
