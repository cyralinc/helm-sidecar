# Configuring certificates for Helm sidecars 

You can use Cyral's default [sidecar-created
certificate](https://cyral.com/docs/sidecars/certificates/overview#sidecar-created-certificate) or use a
[custom certificate](https://cyral.com/docs/sidecars/certificates/overview#custom-certificate) to secure
the communications performed by the sidecar.

In this page we provide two ways of deploying a custom certificate to
your `helm` sidecar:

- using `cert-manager` to provision the certificate automatically on your cluster; or
- provisioning a certificate signed by the Certificate Authority of your choice.

The first approach creates a stack for certificate management based on
a set of certificate signing and validation methods. The second approach 
creates a `kubernetes` secret containing the information from the
provisioned certificate.

## `cert-manager` provisioned certificate

This set of instructions makes use of [`cert-manager`](https://cert-manager.io/docs/), an extension to `kubernetes`
that uses CRDs to easily manage certificates from different sources.

### Prerequisites

1. Have a [Kubernetes cluster](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment) deployed.
2. [Install Helm 3](https://helm.sh/docs/intro/install/).
3. Have [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) permissions to install CRDs.

### Installing cert-manager

`cert-manager` installation is well documented in [their documentation](https://cert-manager.io/docs/installation/). We recommend
installing it using `helm`.

To install the latest version of `cert-manager`, run the following command:
```bash
helm upgrade -i cert-manager cert-manager -n cert-manager --repo https://charts.jetstack.io --create-namespace --set installCRDs=true
```

### Creating an issuer

An `Issuer` is a `cert-manager` resource that configures how your certificate will be validated. The issuer's configuration will vary
with your cloud provider and validation method. Refer to the [project documentation](https://cert-manager.io/docs/configuration/) to create an issuer.


### Creating the certificate

After creating an issuer, you need to create a `Certificate` resource so that `cert-manager` starts the validation process for your domain using the
configuration created in the `Issuer` from the last step. The certificate should look something like this:

```yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: acme-crt
  namespace: <sidecar namespace>
spec:
  secretName: <certificate secret name>
  dnsNames:
  - my-sidecar.my-domain.com
  issuerRef:
    name: <your issuer name>
    # We can reference ClusterIssuers by changing the kind here.
    # The default value is Issuer (i.e. a locally namespaced Issuer)
    kind: Issuer
    group: cert-manager.io
```

This will trigger a chain that will eventually create a `tls` secret with the name `<certificate secret name>` on the `<sidecar namespace>` namespace.

**The secret name must be provided to the sidecar Helm chart.  See [how to do
it here](#provide-custom-certificate-to-the-sidecar).**

**WARNING:** By default, the sidecar contains permissions to `get` and `watch` `v1/Secret` resources in the  namespace
it's created in. If you are using a custom `ServiceAccount`, make sure it has these permissions attached to it.

## Provide custom certificate to the sidecar

To provide a custom certificate to the sidecar, first create a secret then provide the
secret name in the values file of the Helm chart.

The `helm` sidecar makes use of [tls secrets](https://kubernetes.io/docs/concepts/configuration/secret/#tls-secrets) to load
custom certificates.

You can create the secret from a PEM encoded certificate file and a key file using the following command:
```bash
kubectl create secret tls my-tls-secret \
  --cert=path/to/cert/file \
  --key=path/to/key/file \
  --namespace <sidecar namespace>
```

To make the sidecar use your custom certificate, provide the name of the secret
to the sidecar Helm chart.

Suppose you created the secrets `my-tls-secret` and `my-ca-secret`, then
provide the following to your values file:

```yaml
cyral:
  sidecar:
    certificates:
      tls:
        existingSecret: "my-tls-secret"
      ca:
        existingSecret: "my-ca-secret"
```

The choice between providing a `tls`, a `ca` secret or *both* will depend on the repositories
used by your sidecar. See the certificate type used by each repository in the 
[sidecar certificates](https://cyral.com/docs/sidecars/deployment/certificates#sidecar-certificate-types) page.