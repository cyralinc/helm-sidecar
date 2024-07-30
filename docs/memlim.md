# Memory Limiting

In addition to configuring the memory capacity of the sidecar's K8s pod (using
the standard `resources` configuration parameters, e.g. requests and limits),
the individual services within the sidecar container each have a default memory
limit. The memory limit is a maximum number of bytes that a service is allowed
to consume. This is useful to prevent a single service from consuming all
available memory available to the sidecar pod and causing other services to fail
as a result. Currently, each "wire" service has a default memory limit of
`512MB` while other services are limited to `128MB`. When a service exceeds its
memory limit, it will panic and exit, causing the sidecar to restart the
service.

Users can override the default memory limits if desired by setting various
environment variables.

## Environment Variables

The following environment variables can be set to override the default memory
limits.

Wires (default `512MB` since `v4.15.1` and `128MB` on all previous versions):

* `CYRAL_DREMIO_WIRE_MAX_MEM`
* `CYRAL_DYNAMODB_WIRE_MAX_MEM`
* `CYRAL_MONGODB_WIRE_MAX_MEM`
* `CYRAL_MYSQL_WIRE_MAX_MEM`
* `CYRAL_ORACLE_WIRE_MAX_MEM`
* `CYRAL_PG_WIRE_MAX_MEM`
* `CYRAL_S3_WIRE_MAX_MEM`
* `CYRAL_SNOWFLAKE_WIRE_MAX_MEM`
* `CYRAL_SQLSERVER_WIRE_MAX_MEM`

Misc. services (default `128MB`):

* `ALERTER_MAX_SYS_SIZE_MB`
* `CYRAL_AUTHENTICATOR_MAX_SYS_SIZE_MB`
* `FORWARD_PROXY_MAX_SYS_SIZE_MB`
* `NGINX_PROXY_HELPER_MAX_SYS_SIZE_MB`
* `SERVICE_MONITOR_MAX_SYS_SIZE_MB`

Values should be set in megabytes (`MB`). For example, to set the memory limit
for the PostgreSQL wire service to `1GB`, set `CYRAL_PG_WIRE_MAX_MEM=1024`.

## Setting Memory Limits via Deployment Parameters

The easiest way to set these environment variables is to use the `extraEnvVars`
deployment parameter. This is a map of key/values, which takes the following
form:

```yaml
extraEnvVars:
  - name: SOME_ENV_VAR
    value: "some value"
  # ...other environment variables...
```

For example, to set the memory limit for the PostgreSQL wire service to `1GB`,
you can add the following to your deployment configuration:

```yaml
extraEnvVars:
  - name: CYRAL_PG_WIRE_MAX_MEM
    value: "1024"
```

You can follow the same pattern to set memory limits for other services.

Additionally, you can use the `extraEnvVarsCM` and `extraEnvVarsSecret`
parameters to reference ConfigMaps and Secrets that contain the environment
variables. This may be useful if you want to manage the environment variables
separately from the deployment configuration values. See
the [README](/README.md)for more information on these parameters.
