<!--- app-name: %%CHART_NAME%% -->

# Cyral sidecar Helm chart

Use this Helm chart to deploy a sidecar to your Kubernetes environment.

Refer to the [quickstart guide](https://github.com/cyral-quickstart/quickstart-sidecar-helm#readme)
for more information on how to use this chart or upgrade your sidecar.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+

## Usage

### Installing the Chart

```console
helm install cyral-sidecar oci://public.ecr.aws/cyral/helm/sidecar
```

### Uninstalling the Chart

To uninstall/delete the `cyral-sidecar` deployment:

```console
helm delete cyral-sidecar
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Advanced

Instructions for advanced deployment configurations are available for the 
following topics:

* [Enable the S3 File Browser](./docs/s3-browser.md)
* [Expose to the Internet](./docs/public-load-balancer.md)
* [Memory limits](./docs/memlim.md)
* [Node scheduling](./docs/node-scheduling.md)
* [Restrict repositories' ports](./docs/port-configuration.md)
* [Set up database accounts through environment variables](./docs/database-accounts/environment-variables.md)
* [Set up database accounts through AWS Secrets Manager](./docs/database-accounts/aws-secrets-manager.md)
* [Set up resources](./docs/resources.md)
* [Sidecar certificates](./docs/certificates.md)
* [Sidecar instance metrics](./docs/metrics.md)
* [Use a pre-existing service account](./docs/pre-existing-sa.md)
* [Values file reference](./docs/values-file.md)

## Parameters

### Required Cyral configuration

| Name                             | Description                                                                                            | Value |
| -------------------------------- | ------------------------------------------------------------------------------------------------------ | ----- |
| `cyral.sidecarId`                | Sidecar identifier                                                                                     | `""`  |
| `cyral.controlPlane`             | Address of the control plane - <tenant>.cyral.com                                                      | `""`  |
| `cyral.credentials.clientId`     | The client ID assigned to the sidecar. Optional - required only if existingSecret is not provided.     | `""`  |
| `cyral.credentials.clientSecret` | The client secret assigned to the sidecar. Optional - required only if existingSecret is not provided. | `""`  |
| `image.tag`                      | Cyral Sidecar image tag (this is the sidecar version)                                                  | `""`  |

### Certificates configuration

| Name                                            | Description                                                                                                    | Value |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------- | ----- |
| `cyral.sidecar.certificates.ca.existingSecret`  | Name of an existing Kubernetes secret containing a private key and a certificate for the internal CA.          | `""`  |
| `cyral.sidecar.certificates.tls.existingSecret` | Name of an existing Kubernetes secret containing a private key and a certificate to terminate TLS connections. | `""`  |

### Cyral deployment properties configuration

| Name                                        | Description                                                                         | Value             |
| ------------------------------------------- | ----------------------------------------------------------------------------------- | ----------------- |
| `cyral.deploymentProperties.cloud`          | Cloud provider where the Cyral Sidecar is hosted.                                   | `""`              |
| `cyral.deploymentProperties.deploymentType` | Deployment type choosen to deploy the Cyral Sidecar. Defaults to `helm-kubernetes`. | `helm-kubernetes` |
| `cyral.deploymentProperties.endpoint`       | Fully qualified domain name that will be used to access the Cyral Sidecar.          | `""`              |

### Snowflake configuration

| Name                                            | Description                                                                                                                                                                                    | Value |
| ----------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `cyral.sidecar.snowflake.idpCertificate`        | The certificate used to verify SAML assertions from the IdP being used with Snowflake. Enter this value as a one-line string with literal new line characters (\n) specifying the line breaks. | `""`  |
| `cyral.sidecar.snowflake.sidecarIdpCertificate` | The public certificate used to verify signatures for SAML Assertions generated by the sidecar. Required if using SSO with Snowflake.                                                           | `""`  |
| `cyral.sidecar.snowflake.sidecarIdpPrivateKey`  | The private key used to sign SAML Assertions generated by the sidecar. Required if using SSO with Snowflake.                                                                                   | `""`  |
| `cyral.sidecar.snowflake.SSOLoginURL`           | The IdP SSO URL for the IdP being used with Snowflake.                                                                                                                                         | `""`  |

### Other Cyral configuration

| Name                               | Description                                                                                                                                   | Value |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- | ----- |
| `cyral.credentials.existingSecret` | Name of an existing Kubernetes secret containing client ID and client secret. The secret must contain the `clientId` and `clientSecret` keys. | `""`  |
| `cyral.sidecar.dnsName`            | Fully qualified domain name that will be used to access the Cyral Sidecar                                                                     | `""`  |

### Common configuration

| Name                | Description                                                                                                       | Value           |
| ------------------- | ----------------------------------------------------------------------------------------------------------------- | --------------- |
| `commonAnnotations` | Common annotations to add to all Cyral Sidecar resources (sub-charts are not considered). Evaluated as a template | `{}`            |
| `commonLabels`      | Common labels to add to all Cyral Sidecar resources (sub-charts are not considered). Evaluated as a template      | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain                                                                                         | `cluster.local` |
| `fullnameOverride`  | String to fully override common.names.fullname template with a string                                             | `""`            |
| `kubeVersion`       | Force target Kubernetes version (using Helm capabilities if not set)                                              | `""`            |
| `nameOverride`      | String to partially override common.names.fullname template with a string (will prepend the release name)         | `""`            |

### Deployment configuration

| Name                           | Description                                                                                                                      | Value  |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------- | ------ |
| `affinity`                     | Affinity for pod assignment                                                                                                      | `{}`   |
| `extraEnvVars`                 | Extra environment variables to be set on Cyral Sidecar containers                                                                | `[]`   |
| `extraEnvVarsCM`               | ConfigMap with extra environment variables                                                                                       | `""`   |
| `extraEnvVarsSecret`           | Secret with extra environment variables                                                                                          | `""`   |
| `extraVolumes`                 | Array of extra volumes to be added to the Cyral Sidecar deployment (evaluated as template). Requires setting `extraVolumeMounts` | `[]`   |
| `nodeAffinityPreset.key`       | Node label key to match Ignored if `affinity` is set.                                                                            | `""`   |
| `nodeAffinityPreset.type`      | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                        | `""`   |
| `nodeAffinityPreset.values`    | Node label values to match. Ignored if `affinity` is set.                                                                        | `[]`   |
| `nodeSelector`                 | Node labels for pod assignment. Evaluated as a template.                                                                         | `{}`   |
| `podAffinityPreset`            | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                              | `""`   |
| `podAntiAffinityPreset`        | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                         | `hard` |
| `replicaCount`                 | Number of Cyral Sidecar replicas to deploy                                                                                       | `1`    |
| `resources`                    | Set container requests and limits for different resources like CPU or memory (essential for production workloads)                | `{}`   |
| `tolerations`                  | Tolerations for pod assignment. Evaluated as a template.                                                                         | `[]`   |
| `updateStrategy.rollingUpdate` | Deployment rolling update configuration parameters.                                                                              | `{}`   |
| `extraContainers`              | Array of additional containers to be added to the deployment pod.                                                                | `[]`   |

### Image configuration

| Name                | Description                                                                                                   | Value                  |
| ------------------- | ------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `image.debug`       | Enable image debug mode                                                                                       | `false`                |
| `image.digest`      | Cyral Sidecar image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                   |
| `image.pullPolicy`  | Cyral Sidecar image pull policy                                                                               | `IfNotPresent`         |
| `image.pullSecrets` | Cyral Sidecar image pull secrets                                                                              | `[]`                   |
| `image.registry`    | Cyral Sidecar image registry                                                                                  | `public.ecr.aws/cyral` |
| `image.repository`  | Cyral Sidecar image repository                                                                                | `cyral-sidecar`        |

### Ports configuration

| Name                  | Description                                                         | Value |
| --------------------- | ------------------------------------------------------------------- | ----- |
| `containerPorts`      | Map of all ports inside Cyral Sidecar container                     | `{}`  |
| `extraContainerPorts` | Array of additional container ports for the Cyral Sidecar container | `[]`  |

### Prometheus metrics

| Name                                       | Description                                                                      | Value   |
| ------------------------------------------ | -------------------------------------------------------------------------------- | ------- |
| `metrics.enabled`                          | Enable exposing Cyral Sidecar metrics to be gathered by Prometheus               | `false` |
| `metrics.podAnnotations`                   | Annotations for enabling prometheus to access the metrics endpoint               | `{}`    |
| `metrics.serviceMonitor.annotations`       | Extra annotations for the ServiceMonitor                                         | `{}`    |
| `metrics.serviceMonitor.enabled`           | Create ServiceMonitor Resource for scraping metrics using PrometheusOperator     | `false` |
| `metrics.serviceMonitor.honorLabels`       | honorLabels chooses the metric's labels on collisions with target labels         | `false` |
| `metrics.serviceMonitor.interval`          | Specify the interval at which metrics should be scraped                          | `30s`   |
| `metrics.serviceMonitor.jobLabel`          | The name of the label on the target service to use as the job name in Prometheus | `""`    |
| `metrics.serviceMonitor.labels`            | Extra labels for the ServiceMonitor                                              | `{}`    |
| `metrics.serviceMonitor.metricRelabelings` | MetricsRelabelConfigs to apply to samples before ingestion                       | `[]`    |
| `metrics.serviceMonitor.namespace`         | Specify the namespace in which the serviceMonitor resource will be created       | `""`    |
| `metrics.serviceMonitor.params`            | Define the HTTP URL parameters used by ServiceMonitor                            | `{}`    |
| `metrics.serviceMonitor.path`              | Define the path used by ServiceMonitor to scrap metrics                          | `""`    |
| `metrics.serviceMonitor.podTargetLabels`   | Used to keep given pod's labels in target                                        | `{}`    |
| `metrics.serviceMonitor.relabelings`       | RelabelConfigs to apply to samples before scraping                               | `[]`    |
| `metrics.serviceMonitor.scrapeTimeout`     | Specify the timeout after which the scrape is ended                              | `""`    |
| `metrics.serviceMonitor.selector`          | ServiceMonitor selector labels                                                   | `{}`    |
| `metrics.serviceMonitor.targetLabels`      | Used to keep given service's labels in target                                    | `{}`    |

### RBAC configuration

| Name          | Description                 | Value  |
| ------------- | --------------------------- | ------ |
| `rbac.create` | Create Role and RoleBinding | `true` |
| `rbac.rules`  | Custom RBAC rules to set    | `[]`   |

### Security context configuration

| Name                                                | Description                                               | Value            |
| --------------------------------------------------- | --------------------------------------------------------- | ---------------- |
| `containerSecurityContext.allowPrivilegeEscalation` | Set container's Security Context allowPrivilegeEscalation | `false`          |
| `containerSecurityContext.enabled`                  | Enabled containers' Security Context                      | `true`           |
| `containerSecurityContext.privileged`               | Set container's Security Context privileged               | `false`          |
| `containerSecurityContext.seccompProfile.type`      | Set container's Security Context seccomp profile          | `RuntimeDefault` |
| `containerSecurityContext.seLinuxOptions`           | Set SELinux options in container                          | `nil`            |
| `containerSecurityContext.readOnlyRootFilesystem`   | Set container's Security Context readOnlyRootFilesystem   | `false`          |
| `containerSecurityContext.runAsNonRoot`             | Set container's Security Context runAsNonRoot             | `true`           |
| `containerSecurityContext.runAsUser`                | Set containers' Security Context runAsUser                | `65534`          |
| `podSecurityContext.enabled`                        | Enabled Cyral Sidecar pods' Security Context              | `true`           |
| `podSecurityContext.fsGroup`                        | Set Cyral Sidecar pod's Security Context fsGroup          | `1001`           |
| `podSecurityContext.fsGroupChangePolicy`            | Set filesystem group change policy                        | `Always`         |
| `podSecurityContext.supplementalGroups`             | Set filesystem extra groups                               | `[]`             |
| `podSecurityContext.sysctls`                        | Set kernel settings using the sysctl interface            | `[]`             |

### Service account configuration

| Name                                          | Description                                               | Value  |
| --------------------------------------------- | --------------------------------------------------------- | ------ |
| `serviceAccount.annotations`                  | Annotations for service account. Evaluated as a template. | `{}`   |
| `serviceAccount.automountServiceAccountToken` | Auto-mount the service account token in the pod           | `true` |
| `serviceAccount.create`                       | Enable creation of ServiceAccount for Cyral Sidecar pod   | `true` |
| `serviceAccount.name`                         | The name of the ServiceAccount to use.                    | `""`   |

### Service configuration

| Name                               | Description                                                                                 | Value          |
| ---------------------------------- | ------------------------------------------------------------------------------------------- | -------------- |
| `service.annotations`              | Service annotations                                                                         | `{}`           |
| `service.clusterIP`                | Cyral Sidecar service Cluster IP                                                            | `""`           |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                        | `Cluster`      |
| `service.loadBalancerClass`        | service Load Balancer class if service type is `LoadBalancer` (optional, cloud specific)    | `""`           |
| `service.loadBalancerIP`           | LoadBalancer service IP address                                                             | `""`           |
| `service.loadBalancerSourceRanges` | Cyral Sidecar service Load Balancer sources                                                 | `[]`           |
| `service.nodePorts`                | Specify the nodePort(s) value(s) for the LoadBalancer and NodePort service types.           | `{}`           |
| `service.ports`                    | Map of Cyral Sidecar service ports                                                          | `{}`           |
| `service.sessionAffinity`          | Session Affinity for Kubernetes service, can be "None" or "ClientIP"                        | `None`         |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                 | `{}`           |
| `service.targetPort`               | Target port reference value for the Loadbalancer service types can be specified explicitly. | `{}`           |
| `service.type`                     | Service type                                                                                | `LoadBalancer` |
