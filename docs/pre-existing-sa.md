# Using a pre-existing service account for a Helm sidecar

When the sidecar is deployed, it creates a role to access some of the
Kubernetes APIs. You may wish to retain control over roles and role
binding, and you may wish to do this outside of your Helm charts. You
can accomplish this by deploying the sidecar using external service
accounts. Below, we explain how to do this.

1. **Create the service account**: You can deploy the Cyral sidecar using
   a Kubernetes service account that you create and manage. Here,
   we'll create a service account. In this command,
   - `SIDECAR_NAMESPACE` is the Kubernetes namespace where the Cyral
     sidecar cluster will run
   - `SIDECAR_SA` is the Kubernetes service account that will deploy and
     run the Cyral sidecar cluster

   ```
   kubectl create sa -n $SIDECAR_NAMESPACE $SIDECAR_SA
   ```

2. **Create the roles and role bindings**: The Cyral sidecar
   requires 3 separate roles:
   - a role for the *sidecar exporter* (service that sends sidecar health
     metrics to the Cyral management console),
   - a role for the sidecar’s *log shipper* that sends
     log data to services such as ELK, and
   - a role for *accessing the Kubernetes secret* with credentials
     needed to access the Cyral control plane.

   Follow the examples below, replacing the names in angle brackets
   with names suitable for your environment:

   ```
   kubectl create role <ROLE FOR EXPORTER> --verb=get --resource=services -n $SIDECAR_NAMESPACE

   kubectl create role <ROLE FOR LOG SHIPPER> --verb=get,watch,list --resource=pods -n $SIDECAR_NAMESPACE

   kubectl create role <ROLE FOR SECRETS> --verb=get,watch,patch --resource=secrets -n $SIDECAR_NAMESPACE
   ```

   Bind the roles to the service account:

   ```
   kubectl create rolebinding <BINDING FOR EXPORTER> --role=<ROLE FOR EXPORTER> --serviceaccount=$SIDECAR_NAMESPACE:$SIDECAR_SA --namespace $SIDECAR_NAMESPACE

   kubectl create rolebinding <BINDING FOR LOG SHIPPER> --role=<ROLE FOR LOG SHIPPER> --serviceaccount=$SIDECAR_NAMESPACE:$SIDECAR_SA --namespace $SIDECAR_NAMESPACE

   kubectl create rolebinding <BINDING FOR SECRETS ROLE> --role=<ROLE FOR SECRETS> --serviceaccount=$SIDECAR_NAMESPACE:$SIDECAR_SA --namespace $SIDECAR_NAMESPACE
   ```

3. **Modify the values.yaml file**: The downloaded `values.yaml` files
   need to be modified to use the above-created service account.
   Note that `serviceAccount.create` must be set to false:

   ```yaml
    serviceAccount:
        name: $SIDECAR_SA
        create: false
   ```
