# Exposing a Helm sidecar to the Internet

To expose the sidecar to the Internet, so it's reachable outside the cluster, we use a `LoadBalancer` type service.
This tells your cluster to provision a load balancer. This request has a different behavior depending on the cloud
provider of your cluster.

## GKE (GCP)

By default, GKE provisions a public IP for any `LoadBalancer` service. If needed, you can check [GKE docs](https://cloud.google.com/kubernetes-engine/docs/how-to/service-parameters) for any special needs for your deployment.

## EKS (AWS)

By default, EKS provisions an internal facing load balancer for a `LoadBalancer` service. To make the load balancer provision a public IP address,
you need to add the following annotations on the `service.annotations` field of the values file:

```yaml
service:
    annotations:
        service.beta.kubernetes.io/aws-load-balancer-type: "external"
        service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
```

You can view a full list of possible annotations on [this page](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/service/annotations).

## OKE (OCI)
By default, OKE provisions a public IP for any `LoadBalancer` service. You can add the following annotation on the `service.annotations` field of the values file if you want OKE to provision an internal load balancer:

```yaml
service:
    annotations:
        service.beta.kubernetes.io/oci-load-balancer-internal: "true"
```

If needed, you can check [OCI](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingloadbalancer.htm) docs for any special needs for your deployment.

## AKS (Azure)
By default, AKS provisions a public IP for any `LoadBalancer` service. If needed, you can check 
[AKS docs](https://docs.microsoft.com/en-us/azure/aks/load-balancer-standard#use-the-public-standard-load-balancer) 
for any special needs for your deployment.
