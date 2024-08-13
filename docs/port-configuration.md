# Restricting ports where users connect to repositories

A single Cyral sidecar cluster usually monitors and protects many
repositories of different types. To make it easy for data users to
connect to these repositories using the port numbers they're
accustomed to, the sidecar cluster exposes multiple ports.
You can restrict or increase the set of exposed ports by changing
the exposed ports in the `values.yaml` file.

## Declaring container ports

On the `values.yaml` file, you can find different parameters related
to ports exposure. The `containerPorts` object specifies which ports
the container will listen on. It has a map of `<port-name>: <port-number>`,
where `<port-name>` is an arbitrary name for the port and `<port-number>`
is an integer to the TCP port. These are the same port numbers used to bind
data repositories on the Control Plane.

```yaml
containerPorts:
  mysql: 3306
  pg: 5432
  mongodb0: 27017
  mongodb1: 27018
  mongodb2: 27019
```

The above example declares some port names (`mysql`, `pg`, `mongodb0`, `mongodb1`,
and `mongodb2`) and their corresponding port numbers. We can refer to these port
names later on to expose them through a Kubernetes service.

## Exposing container ports

To expose container ports to external traffic or to other pods within the cluster, you need to set
service ports. The `service` object defines `ports` and `targetPorts`. The `ports` property specifies
the ports the Service will expose, while `targetPort` maps the Service ports to the container's
`containerPorts` declared previously.

In `service.ports`, you define a map of `<port-name>: <port-number>` where the Kubernetes service
will listen on. Then, you can use `service.targetPorts` to map service ports to container ports
in the format `<service-port-name>: <container-port-name>`. For instance, assuming you defined a
container port as `mysql: 3306` and a service port as `mysql: 3306`, you can set `mysql: mysql`
in `targetPorts` to create a link between them.

Following is an example of how to set service ports.

```yaml
service:
  ...
  ports:
    mysql: 3306
    pg: 5432
    mongodb0: 27017
    mongodb1: 27018
    mongodb2: 27019
  targetPort:
    mysql: mysql
    pg: pg
    mongodb0: mongodb0
    mongodb1: mongodb1
    mongodb2: mongodb2
```

The above example expose ports `3306`, `5432`, `27017`, `27018`, and `27019` on the service.
