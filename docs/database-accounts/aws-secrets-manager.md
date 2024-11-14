# Setting up database accounts to a Helm sidecar through AWS Secrets Manager

Cyral recommends setting up database accounts to a Helm sidecar
using [environment variable](./environment-variables.md) referencing Kubernetes secrets.

If you prefer to use AWS Secrets Manager instead, you are required to provide the AWS 
credentials that the sidecar will use to access the AWS secret containing the database 
account. The Helm sidecar allows for one of the two following options to provide 
these credentials: 

* Add AWS credentials directly to the values file, which will then
create a Kubernetes secret automatically to store them.
* Add AWS credentials to a Kubernetes secret with the credentials and then 
provide this secret name to the sidecar.

Read more information about [database accounts](https://cyral.com/docs/data-repos/access-rules/database-accounts/)
in our public docs.


## Add AWS credentials directly to the values file

To provide the AWS credentials directly to the values file, you need to add
the section `aws` to your `values.yaml` as follows:

```yaml
aws:
  enabled: true
  secretKey: <your secret key>
  accesskeyId: <your access key id>
```

The credentials provided to `secretKey` and `accesskeyId` will be  stored in a 
Kubernetes secret and accessed by the sidecar through environment variables.

## Add AWS credentials through a Kubernetes secret

If you prefer to manually create a Kubernetes secret with the AWS credentials,
follow the format below:

```yaml
apiVersion: v1
kind: Secret
stringData:
  AWS_SECRET_KEY: <your secret key>
  AWS_ACCESS_KEY_ID: <your access key id>
```

Once the secret is created, add the `aws` section to your `values.yaml`
informing the secret name as follows:

```yaml
aws:
  enabled: true
  existingSecret: <SECRET_NAME>
```