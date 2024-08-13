# Scheduling nodes for a Helm sidecar

There are many ways to specify to which nodes your sidecar should and should
not be scheduled to.

## Node Selectors

In the `cyral-sidecar` chart, use the variable `nodeSelector` to force
your sidecar pods to run on a specific set of Kubernetes cluster
nodes. The syntax uses a label-value pair to specify the nodes:

```yaml
nodeSelector:
  SOME_LABEL: SOME_VALUE
```

Learn more about [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector).

## Node Affinity

To set the node affinity for the pods, use the variable `affinity`. This will let you use
a very expressive language to define affinities and anti affinities for each pod on the deployment.

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/e2e-az-name
          operator: In
          values:
          - e2e-az1
          - e2e-az2
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 1
      preference:
        matchExpressions:
        - key: another-node-label-key
          operator: In
          values:
          - another-node-label-value
```

**TIP**: You can configure presets for pod anti-affinity and pod affinity using the 
`podAntiAffinityPreset` and `podAffinityPreset` keys in the [values file](./values-file.md#deployment-configuration).

Learn more about [affinity and anti affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity).

## Pod tolerations

You can set tolerations for your pod, so that it doesn't get scheduled to a tainted
node. To set the tolerations use the variable `tolerations`.

```yaml
tolerations:
- key: "key1"
  operator: "Equal"
  value: "value1"
  effect: "NoSchedule"
```

Learn more about [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).
