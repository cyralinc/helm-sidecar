#### Enable the S3 File Browser

To configure the sidecar to work on the S3 File Browser, set the following extra parameters under the service key of your values file:

```
cyral:
  deploymentProperties:
    endpoint: "<CNAME>" # ex: "sidecar.custom-domain.com"
service:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "arn:aws:acm:<REGION>:<AWS_ACCOUNT>:certificate/<CERTIFICATE_ID>"
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "tcp"
    service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "443
```

The CNAME provided in `cyral.deploymentProperties.endpoint` must be created
after the deployment pointing to the sidecar load balancer.
See [Add a CNAME or A record for the sidecar](https://cyral.com/docs/sidecars/manage/alias).

All the Helm parameters used above are documented in the 
[values file configuration reference](./values-file.md). 
For more details about the S3 File Browser configuration, check the 
[Enable the S3 File Browser](https://cyral.com/docs/how-to/enable-s3-browser) 
documentation.
