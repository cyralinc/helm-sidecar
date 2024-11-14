# Setting up database accounts to a Helm sidecar through environment variables

Cyral recommends setting up database accounts to a Helm sidecar
using environment variables referencing Kubernetes secrets.

Read more information about [database accounts](https://cyral.com/docs/data-repos/access-rules/database-accounts/)
in our public docs.

## Add the credentials to your cluster

To add credentials for a repository using kubernetes secrets and environment
variables, you need to create a secret containing those credentials in the
same namespace as the sidecar you are deploying.

Use one of the next 3 options in the sections below to create a secret: 
- from a file containing the credentials
- from a literal in the command line
- from a secret yaml file

For the selected option, define the following variables:
- `SIDECAR_NAMESPACE`: namespace that the sidecar will be deployed to.
- `SECRET_NAME`: name of the secret that will contain the credentials.
- `CREDENTIALS_FILE`: name of the file containing the credentials.
- `CREDENTIALS_CONTENT`: credentials content.

### Create a secret from a file containing the credentials

```bash
kubectl create secret generic \
  --from-file credentials=$CREDENTIALS_FILE \
  -n $SIDECAR_NAMESPACE $SECRET_NAME
```

### Create a secret from a literal in the command line

```bash
kubectl create secret generic \
  --from-literal credentials=$CREDENTIALS_CONTENT \
  -n $SIDECAR_NAMESPACE $SECRET_NAME
```

### Create a secret from a secret yaml file

Create a file named `secret.yaml` with the following contents:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: $SECRET_NAME
  namespace: $SIDECAR_NAMESPACE
stringData:
  credentials: |
    $CREDENTIALS_CONTENT
```

Apply the file on your cluster with `kubectl`:

```bash
kubectl apply -f secret.yaml
```

## Configure the sidecar to fetch the environment variables from the credentials

With the secret created, you need to add an environment variable to the `authenticator`
field of the `values.yaml` file used to create the sidecar.

```yaml
authenticator:
  extraEnvs:
  - name: CYRAL_DBSECRETS_<env-var-configured-in-the-control-plane>
    valueFrom:
      secretKeyRef:
        name: $SECRET_NAME
        key: credentials
```

## Multiple credentials in a single secret

You can add multiple values on each of the secret creation methods, so that
you don't need to update the `values.yaml` file on each new repository.

Use one of the next 3 options in the sections below to create a secret: 
- from a file containing the credentials
- from a literal in the command line
- from a secret yaml file

### Create a secret from a file containing the credentials

```bash
kubectl create secret generic \
  -n $SIDECAR_NAMESPACE $SECRET_NAME \
  --from-file repo1=repo1_credentials.json \
  --from-file repo2=repo2_credentials.json
  # ...
```

### Create a secret from a literal in the command line

```bash
kubectl create secret generic \
  -n $SIDECAR_NAMESPACE $SECRET_NAME \
  --from-literal repo1=<repo1 credentials> \
  --from-literal repo2=<repo2 credentials>
  # ...
```

### Create a secret from a secret yaml file

Create a file named `secret.yaml` with the following contents:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: $SECRET_NAME
  namespace: $SIDECAR_NAMESPACE
stringData:
  repo1: |
    <repo1 credentials>
  repo2: |
    <repo2 credentials>
    ...
```

Apply the file to your cluster with `kubectl`:

```bash
kubectl apply -f secret.yaml
```

To add them all, just add multiple environment variables in the `values.yaml` file.

```yaml
authenticator:
  extraEnvs:
  - name: CYRAL_DBSECRETS_<repo1 env var>
    valueFrom:
      secretKeyRef:
        name: $SECRET_NAME
        key: repo1
  - name: CYRAL_DBSECRETS_<repo2 env var>
    valueFrom:
      secretKeyRef:
        name: $SECRET_NAME
        key: repo2
  ...
```