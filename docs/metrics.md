# Reading metrics from Helm sidecars

**NOTE:** You can look at all the metrics definitions and what they mean on our [metrics reference page](https://cyral.com/docs/sidecars/monitoring/metrics)

Metric collection on the `helm` sidecar can be configured in numerous ways, depending
on the `Prometheus` configuration for your `Kubernetes` cluster. You can
set the metrics port by adding the following to your `values.yaml` file:

```yaml
containerPorts:
  metrics: 9000 # this is the default value
```

By default, this port will not be exposed on the `Service` object created by the `helm` chart.
To enable its exposure, you can add the following to your `values.yaml` file:

```yaml
service:
  ports:
    metrics: 9000
  targetPort:
    metrics: metrics
```

## Prometheus configuration

### Service Monitor discovery configuration

The sidecar `helm` chart packages a `ServiceMonitor` object which can be used
in conjunction with a [`prometheus operator`](https://github.com/prometheus-operator/prometheus-operator) to
monitor all pods in the sidecar's `Deployment`. To enable the service monitor, you
can add the following to your `values.yaml` file:

```yaml
metrics:
  serviceMonitor:
    enabled: true
```

**NOTE:** There are many other configuration options for the `ServiceMonitor` object,
you can look at the default `values.yaml` file to know all the options.

### Annotation based Prometheus discovery configuration

You can add common `Prometheus` annotations by adding the following
to your `values.yaml` file:

```yaml
podAnnotations:
  "prometheus.io/scrape": "true"
  "prometheus.io/port": "9000"
```

**NOTE:** You can look at configuring `Prometheus` service discovery for `Kubernetes`
on [Prometheus' documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#kubernetes_sd_config)

## Datadog configuration

Datadog metric scraping on Kubernetes can be done in several different ways, and
refer to [their documentation](https://docs.datadoghq.com/containers/kubernetes/prometheus/?tab=kubernetesadv2) for
a more in depth explanation on Datadog metrics collection on Kubernetes.

Metrics are exposed through the `metrics-aggregator` container, on the `metrics.port` port, and are on `OpenMetrics` format,
so a sample annotation you can create by changing your `values.yaml` file is the following:

```yaml
podAnnotations:
  ad.datadoghq.com/metrics-aggregator.checks: |
      {
        "openmetrics": {
          "init_config": {},
          "instances": [
            {
              "openmetrics_endpoint": "http://%%host%%:9000/metrics ",
              "namespace": "cyral",
              "metrics": ["cyral*", "up"]
            }
          ]
        }
      }
```

This example would expose any metrics starting with `cyral` and the `up` metric
to Datadog, on the `cyral` namespace.
