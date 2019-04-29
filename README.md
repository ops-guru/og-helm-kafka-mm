# Kafka MirrorMaker Helm Chart

Helm Chart for Production Grade Kafka MirrorMaker deployment on Kubernetes inspired by Confluent Helm charts (https://github.com/confluentinc/cp-helm-charts)

## Pre-requirements:

- Kubectl
- GKE Cluster (Kubernetes 1.9.2+)
- Helm 2.8.2+
- A healthy and accessible Kafka Cluster

## Deployment on GKE:

```console
// create cluster
gcloud container clusters create test
gcloud container clusters get-credentials test

//initialise helm
helm init

// override helm issue with rbac
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

//deploy mirrormaker
helm install --set kafka.consumerConfig.bootstrap\.servers="dev3-kafka:9092",kafka.producerConfig.bootstrap\.servers="dev4-kafka:9092"  ./og-kafka-mm/
```

## Docker Image Source:

* [DockerHub -> opsguruhub](https://hub.docker.com/u/opsguruhub/)

(Also included in `./docker-src`)


### Kafka MirrorMaker Deployment

The configuration parameters in this section control the resources requested and utilized by the `og-kafka-mm` chart.

| Parameter         | Description                           | Default   |
| ----------------- | ------------------------------------- | --------- |
| `replicaCount`    | The number of Kafka Kafka MirrorMaker Servers.  | `1`       |

### Image

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image` | Docker Image of Kafka MirrorMaker. | `opsguruhub/og-kafka-mm` |
| `imageTag` | Docker Image Tag of Kafka MirrorMaker. | `latest` |
| `imagePullPolicy` | Docker Image Tag of Kafka MirrorMaker. | `IfNotPresent` |
| `imagePullSecrets` | Secrets to be used for private registries. | see [values.yaml](values.yaml) for details |

### Kafka MM JVM Heap Options

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `heapOptions` | The JVM Heap Options for Kafka MirrorMaker | `"-Xms1024M -Xmx1024M"` |

### Resources

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `resources.requests.cpu` | The amount of CPU to request. | see [values.yaml](values.yaml) for details |
| `resources.requests.memory` | The amount of memory to request. | see [values.yaml](values.yaml) for details |
| `resources.requests.limit` | The upper limit CPU usage for a Kafka Connect Pod. | see [values.yaml](values.yaml) for details |
| `resources.requests.limit` | The upper limit memory usage for a Kafka Connect Pod. | see [values.yaml](values.yaml) for details |

### Annotations

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `podAnnotations` | Map of custom annotations to attach to the pod spec. | `{}` |

### JMX Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `jmx.port` | The jmx port which JMX style metrics are exposed. | `9998` |
| `jmx.enabled` | Whether or not to install Prometheus JMX Exporter as a sidecar container and expose JMX metrics to Prometheus. | `true` |

### Prometheus JMX Exporter Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `prometheus.jmx.image` | Docker Image for Prometheus JMX Exporter container. | `solsson/kafka-prometheus-jmx-exporter@sha256` |
| `prometheus.jmx.imageTag` | Docker Image Tag for Prometheus JMX Exporter container. | `6f82e2b0464f50da8104acd7363fb9b995001ddff77d248379f8788e78946143` |
| `prometheus.jmx.port` | JMX Exporter Port which exposes metrics in Prometheus format for scraping. | `5556` |
| `prometheus.jmx.resources` | JMX Exporter resources configuration. | see [values.yaml](values.yaml) for details |

### Deployment Topology

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `nodeSelector` | Dictionary containing key-value-pairs to match labels on nodes. When defined pods will only be scheduled on nodes, that have each of the indicated key-value pairs as labels. Further information can be found in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/) | `{}`
| `tolerations`| Array containing taint references. When defined, pods can run on nodes, which would otherwise deny scheduling. Further information can be found in the [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/) | `{}`

## Dependencies

### Kafka

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `kafka.topicWhitelist` | Regex for a topic whitelist | `".*"` |
| `kafka.numStreams` | Number of consumers to create | `"1"` |
| `kafka.overrideGroupId` | Specify custom group.id. Do not specify group.id in `kafka.consumerConfig` - use this variable to override the default | `".Release.Name"`
| `kafka.consumerProperties` | Kafka consumer settings. This should include `kafka.bootstrap.servers` |  |
| `kafka.producerProperties` | Kafka producer settings. This should include `kafka.bootstrap.servers` |  |
