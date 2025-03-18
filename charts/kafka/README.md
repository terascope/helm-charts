# Apache Kafka Helm Chart

![Version: 1.2.0](https://img.shields.io/badge/Version-1.2.0-informational?style=flat-square) ![AppVersion: 3.7.1](https://img.shields.io/badge/AppVersion-3.7.1-informational?style=flat-square)

This is an implementation of Kafka StatefulSet found here:

* <https://github.com/Yolean/kubernetes-kafka>

## Source Code

* <https://github.com/helm/charts/tree/master/incubator/kafka>
* <https://github.com/Yolean/kubernetes-kafka>
* <https://github.com/apache/kafka>
* <https://github.com/terascope/helm-charts>

## Prerequisites

* `apache/kafka` version 3.7.0 or later

* Kubernetes version 1.22 or later

* PV support on underlying infrastructure

* Requires at least `v2.0.0-beta.1` version of helm to support
  dependency management with requirements.yaml

## StatefulSet Details

* <https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/>

## StatefulSet Caveats

* <https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#limitations>

## Chart Details

This chart will do the following:

* Implement a dynamically scalable kafka cluster using Kubernetes StatefulSets

* Run kafka in KRaft mode with each process acting as a broker and a controller

* Expose Kafka protocol endpoints via NodePort services (optional)

### Installing the Chart

Create a kubernetes cluster. See the [kind quick start guide](https://kind.sigs.k8s.io/docs/user/quick-start/) to run kubernetes locally in docker.

```bash
kind create cluster
```

#### Install the chart from a local copy

Clone this repo then `cd` into the repo.

To install the chart with the release name `kafka` in the default
namespace:

```bash
helm install kafka .
```

If using a dedicated namespace(recommended) then make sure the namespace
exists with:

```bash
kubectl create ns kafka
helm install kafka --namespace kafka .
```

#### Install the chart from the terascope repository

To install the chart with the release name `kafka` in the default
namespace:

```bash
helm repo add terascope https://terascope.github.io/helm-charts/
helm install kafka terascope/kafka
```

If using a dedicated namespace(recommended) then make sure the namespace
exists with:

```bash
helm repo add terascope https://terascope.github.io/helm-charts/
kubectl create ns kafka
helm install kafka --namespace kafka terascope/kafka
```

**NOTE**: The install command output will contain instructions for setting up a test client pod, and commands for listing topics, creating a topic, and producing and consuming messages.

The chart can be customized using the
following configurable parameters:

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicas | int | `3` | Kafka Brokers created by StatefulSet |
| image | string | `"apache/kafka"` | Kafka Container image name |
| imageTag | string | `"3.7.1"` | Kafka Container image tag |
| imagePullPolicy | string | `"IfNotPresent"` | Kafka Container imagePullPolicy ref: http://kubernetes.io/docs/user-guide/images/#pre-pulling-images |
| resources | object | `{}` | Kafka resource requests and limits ref: http://kubernetes.io/docs/user-guide/compute-resources/ |
| kafkaHeapOptions | string | `"-Xmx1G -Xms1G"` | Kafka broker JVM heap options |
| securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000}` | Optional Kafka Container Security context |
| updateStrategy | object | `{"type":"OnDelete"}` | The StatefulSet Update Strategy which Kafka will use when changes are applied. ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies |
| podManagementPolicy | string | `"Parallel"` | Start and stop pods in Parallel or OrderedReady (one-by-one.)  Note - Can not change after first release. ref: https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/#pod-management-policy |
| secrets | object | `{}` | Pass any secrets to the kafka pods. Each secret will be passed as an environment variable by default. The secret can also be mounted to a specific path if required. Environment variable names are generated as: `<secretName>_<secretKey>` (All upper case) |
| logSubPath | string | `"logs"` | The subpath within the Kafka container's PV where logs will be stored. This is combined with `persistence.mountPath`, to create, by default: /opt/kafka/data/logs |
| schedulerName | string | `nil` | Name of Kubernetes scheduler (other than the default), e.g. "stork". ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/ |
| serviceAccountName | string | `nil` | Name of Kubernetes serviceAccount. serviceAccount Useful when using images in custom repositories |
| priorityClassName | string | `nil` | Name of Kubernetes Pod PriorityClass. https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass |
| affinity | object | `{}` | Defines affinities and anti-affinities for pods as defined in: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity preferences |
| nodeSelector | object | `{}` | Node labels for pod assignment ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector |
| topologySpreadConstraints | list | `[]` | Control how Pods are spread across your cluster |
| readinessProbe.initialDelaySeconds | int | `60` | Number of seconds before probe is initiated. |
| readinessProbe.periodSeconds | int | `60` | How often (in seconds) to perform the probe. |
| readinessProbe.timeoutSeconds | int | `10` | Number of seconds after which the probe times out. |
| readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| readinessProbe.failureThreshold | int | `10` | After the probe fails this many times, pod will be marked Unready. |
| livenessProbe.initialDelaySeconds | int | `480` | Number of seconds before probe is initiated. |
| livenessProbe.periodSeconds | int | `60` | How often (in seconds) to perform the probe. |
| livenessProbe.timeoutSeconds | int | `30` | Number of seconds after which the probe times out. |
| livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| livenessProbe.failureThreshold | int | `10` | After the probe fails this many times, pod will be marked Unready. |
| terminationGracePeriodSeconds | int | `600` | Period to wait for broker graceful shutdown (sigterm) before pod is killed (sigkill) |
| tolerations | list | `[]` | Tolerations for nodes that have taints on them. Useful if you want to dedicate nodes to just run kafka https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| service.broker.port | int | `9092` | Broker port to be used for the service. |
| service.broker.targetPort | string | `"kafka"` | Broker target port to be used for the service. |
| headless.annotations | list | `[]` | List of annotations for the headless service. https://kubernetes.io/docs/concepts/services-networking/service/#headless-services |
| headless.broker.plaintext.port | int | `9092` | Broker plaintext port to be used for the headless service. |
| headless.broker.plaintext.targetPort | string | `nil` | Broker plaintext target port to be used for the headless service. This is not a required value. |
| headless.broker.ssl.port | int | `9094` | Broker ssl port to be used for the headless service. |
| headless.broker.ssl.targetPort | string | `nil` | Broker ssl target port to be used for the headless service. This is not a required value. |
| headless.controller.port | int | `9093` | Controller port to be used for the headless service. |
| headless.controller.targetPort | string | `nil` | Controller target port to be used for the headless service. This is not a required value. |
| clusterDomain | string | `"cluster.local"` | Domain in which to advertise Kafka listeners |
| extraInitContainers | string | `nil` | Additional Kafka init containers. Specified as a YAML list.  |
| extraContainers | string | `nil` | Additional Kafka sidecar containers. Specified as a YAML list.  |
| extraVolumes | string | `nil` | Additional Kafka volumes. Specified as a YAML list. |
| extraVolumeMounts | string | `nil` | Additional Kafka volume mounts. Specified as a YAML list. |
| external.enabled | bool | `false` | If True, exposes Kafka brokers via NodePort (PLAINTEXT by default) |
| external.type | string | `"NodePort"` | Service Type: can be either NodePort or LoadBalancer |
| external.externalTrafficPolicy | string | `"Local"` | Service desires to route external traffic to node-local(Local) or cluster-wide(Cluster) endpoints. |
| external.annotations | object | `{}` | Additional annotations for the external service. |
| external.labels | object | `{}` |  |
| external.dns.useInternal | bool | `false` | If True, add Annotation for internal DNS service |
| external.dns.useExternal | bool | `true` | If True, add Annotation for external DNS service |
| external.distinct | bool | `false` | If using external service type LoadBalancer and external dns, set distinct to true below. This creates an A record for each statefulset pod/broker. You should then map the A record of the broker to the EXTERNAL IP given by the LoadBalancer in your DNS server. |
| external.servicePort | int | `19092` | TCP port configured at external services (one per pod) to relay from NodePort to the external listener port. |
| external.firstListenerPort | int | `31090` | TCP port which is added pod index number to arrive at the port used for NodePort and external listener port. |
| external.domain | string | `"cluster.local"` | Domain in which to advertise Kafka external listeners. |
| external.loadBalancerIP | list | `[]` | Add Static IP to the type Load Balancer. Depends on the provider if enabled |
| external.loadBalancerSourceRanges | list | `[]` | Add IP ranges that are allowed to access the Load Balancer. |
| external.init.image | string | `"lwolf/kubectl_deployer"` | Init image |
| external.init.imageTag | string | `"0.4"` | Init image tag |
| external.init.imagePullPolicy | string | `"IfNotPresent"` | Init image pull policy |
| podAnnotations | object | `{}` | Annotation to be added to Kafka pods |
| podLabels | object | `{}` | Labels to be added to Kafka pods |
| podDisruptionBudget | object | `{}` | Define a Disruption Budget for the Kafka Pods |
| configurationOverrides | object | `{}` | Specify any Kafka configuration setting overrides you would like set on the StatefulSet here in map format, as defined in the official docs. ref: https://kafka.apache.org/documentation/#brokerconfigs  |
| envOverrides | object | `{}` | Add additional Environment Variables in the dictionary format.   key: "value" |
| additionalPorts | object | `{}` | A collection of additional ports to expose on brokers (formatted as normal containerPort yaml). Useful when the image exposes metrics (like prometheus, etc.) through a javaagent instead of a sidecar. |
| persistence.enabled | bool | `true` | Use a PVC to persist data |
| persistence.size | string | `"1Gi"` | The size of the PersistentVolume to allocate to each Kafka Pod in the StatefulSet. For production servers this number should likely be much larger. |
| persistence.mountPath | string | `"/opt/kafka/data"` | The location within the Kafka container where the PV will mount its storage and Kafka will store its logs. |
| persistence.storageClass | string | `nil` | Storage class of backing PVC |
| jmx.configMap.enabled | bool | `true` | Enable the default ConfigMap for JMX, note a configMap is needed |
| jmx.configMap.overrideConfig | object | see `values.yaml` | Allows config file to be generated by passing values to ConfigMap |
| jmx.configMap.overrideName | string | `""` | Allows setting the name of the ConfigMap to be used |
| jmx.port | int | `5555` | The jmx port which JMX style metrics are exposed (note: these are not scrapeable by Prometheus) |
| jmx.remote.enabled | bool | `true` | Enable remote JMX access |
| jmx.remote.localOnly | bool | `false` | Block all remote access |
| jmx.remote.ssl | bool | `false` | Require ssl to connect remotely |
| jmx.remote.authenticate | bool | `false` | Require remote authentication |
| jmx.whitelistObjectNames | list | see `values.yaml` | Allows setting which JMX objects you want to expose via JMX stats to JMX Exporter |
| prometheus.jmx.enabled | bool | `false` | Whether or not to expose JMX metrics to Prometheus |
| prometheus.jmx.image | string | `"docker.io/solsson/kafka-prometheus-jmx-exporter@sha256"` | JMX exporter container image |
| prometheus.jmx.imageTag | string | `"70852d19ab9182c191684a8b08ac831230006d82e65d1db617479ea27884e4e8"` | JMX exporter container image tag |
| prometheus.jmx.interval | string | `"10s"` | Interval at which Prometheus scrapes JMX metrics, note: only used by Prometheus Operator |
| prometheus.jmx.scrapeTimeout | string | `"10s"` | Timeout at which Prometheus timeouts scrape run, note: only used by Prometheus Operator |
| prometheus.jmx.port | int | `5555` | JMX Exporter Port which exposes metrics in Prometheus format for scraping |
| prometheus.jmx.resources | object | `{}` | Allows setting resource limits for jmx sidecar container |
| prometheus.kafka.enabled | bool | `false` | Whether or not to create a separate Kafka exporter |
| prometheus.kafka.image | string | `"docker.io/danielqsj/kafka-exporter"` | Kafka Exporter container image |
| prometheus.kafka.imageTag | string | `"v1.8.0"` | Kafka Exporter container image tag |
| prometheus.kafka.interval | string | `"10s"` | Interval at which Prometheus scrapes Kafka metrics, note: only used by Prometheus Operator |
| prometheus.kafka.scrapeTimeout | string | `"10s"` | Timeout at which Prometheus timeouts scrape run, note: only used by Prometheus Operator |
| prometheus.kafka.port | int | `9308` | Kafka Exporter Port which exposes metrics in Prometheus format for scraping |
| prometheus.kafka.resources | object | `{}` | Allows setting resource limits for kafka-exporter pod |
| prometheus.kafka.tolerations | list | `[]` | Tolerations for nodes that have taints on them. Useful if you want to dedicate nodes to just run kafka-exporter https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/ |
| prometheus.kafka.affinity | object | `{}` | Pod scheduling preferences (by default keep pods within a release on separate nodes). By default we don't set affinity. ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity |
| prometheus.kafka.nodeSelector | object | `{}` | Node labels for pod assignment ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector |
| prometheus.operator.enabled | bool | `false` | True if using the Prometheus Operator, False if not |
| prometheus.operator.serviceMonitor.namespace | string | `"monitoring"` | Namespace in which to install the ServiceMonitor resource. Default to kube-prometheus install. |
| prometheus.operator.serviceMonitor.releaseNamespace | bool | `false` | Set namespace to release namespace |
| prometheus.operator.serviceMonitor.selector | object | `{"prometheus":"kube-prometheus"}` | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install |
| prometheus.operator.serviceMonitor.relabelings | list | see `values.yaml` | Relabel a target before scrape |
| prometheus.operator.serviceMonitor.metricRelabelings | list | see `values.yaml` | Relabel a metric before sample ingestion |
| prometheus.operator.prometheusRule.enabled | bool | `false` | True to create a PrometheusRule resource for Prometheus Operator, False if not |
| prometheus.operator.prometheusRule.namespace | string | `"monitoring"` | Namespace in which to install the PrometheusRule resource. Default to kube-prometheus install. |
| prometheus.operator.prometheusRule.releaseNamespace | bool | `false` | Set namespace to release namespace |
| prometheus.operator.prometheusRule.selector | object | `{"prometheus":"kube-prometheus"}` | Default to kube-prometheus install (CoreOS recommended), but should be set according to Prometheus install |
| prometheus.operator.prometheusRule.rules | object | `{}` | Define the prometheus rules. See values file for examples. |
| prometheus.agent.enabled | bool | `false` | Whether or not to expose JMX metrics to Prometheus as a Java Agent (alternative to prometheus.jmx) |
| prometheus.agent.version | string | `"1.1.0"` | JMX Agent Exporter version https://github.com/prometheus/jmx_exporter/releases |
| prometheus.agent.interval | string | `"30s"` | Interval at which Prometheus scrapes JMX metrics, note: only used by Prometheus Operator |
| prometheus.agent.scrapeTimeout | string | `"30s"` | Timeout at which Prometheus timeouts scrape run, note: only used by Prometheus Operator |
| prometheus.agent.port | int | `5557` | JMX Exporter Port which exposes metrics in Prometheus format for scraping |
| prometheus.agent.selector | object | `{}` | Custom label selector |
| configJob.backoffLimit | int | `6` | Specify the number of retries before considering kafka-config job as failed. https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/#pod-backoff-failure-policy |
| topics | list | `[]` | List of topics to create & configure. Can specify name, partitions, replicationFactor, reassignPartitions, config. See values.yaml **WARNING**: this feature has not been implemented |
| testsEnabled | bool | `true` | Enable/disable the chart's tests.  Useful if using this chart as a dependency of another chart and you don't want these tests running when trying to develop and test your own chart. |

Specify parameters using `--set key=value[,key=value]` argument to `helm install`

Alternatively a YAML file that specifies the values for the parameters can be provided like this:

```bash
helm install kafka -f values.yaml terascope/kafka
```

### Zookeeper Chart

Apache Kafka is dropping support for zookeeper in v4.0 and was marked [deprecated](https://kafka.apache.org/documentation/#zk_depr) in v3.5. KRaft is now used for metadata management by default. With that in mind we have eliminated zookeeper from this chart and set up all default config values needed for [KRaft](https://kafka.apache.org/documentation/#kraft).

### Connecting to Kafka from inside Kubernetes

You can connect to Kafka by running a simple pod in the K8s cluster like this with a configuration like this:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: testclient
  namespace: kafka
spec:
  containers:
  - name: kafka
    image: solsson/kafka:0.11.0.0
    command:
      - sh
      - -c
      - "exec tail -f /dev/null"
```

Once you have the testclient pod above running, you can list all kafka
topics with:

`kubectl -n kafka exec -ti testclient -- /opt/kafka/bin/kafka-topics.sh --bootstrap-server kafka:9092 --list`

## Extensions

Kafka has a rich ecosystem, with lots of tools. This sections is intended to compile all of those tools for which a corresponding Helm chart has already been created.

* [Schema-registry](https://github.com/kubernetes/charts/tree/master/incubator/schema-registry) -  A confluent project that provides a serving layer for your metadata. It provides a RESTful interface for storing and retrieving Avro schemas.

## Connecting to Kafka from outside Kubernetes

### NodePort External Service Type

Review and optionally override to enable the example text concerned with external access in `values.yaml`.

Once configured, you should be able to reach Kafka via NodePorts, one per replica. In kops where private,
topology is enabled, this feature publishes an internal round-robin DNS record using the following naming
scheme. The external access feature of this chart was tested with kops on AWS using flannel networking.
If you wish to enable external access to Kafka running in kops, your security groups will likely need to
be adjusted to allow non-Kubernetes nodes (e.g. bastion) to access the Kafka external listener port range.

```yaml
{{ .Release.Name }}.{{ .Values.external.domain }}
```

If `external.distinct` is set theses entries will be prefixed with the replica number or broker id.

```yaml
{{ .Release.Name }}-<BROKER_ID>.{{ .Values.external.domain }}
```

Port numbers for external access used at container and NodePort are unique to each container in the StatefulSet.
Using the default `external.firstListenerPort` number with a `replicas` value of `3`, the following
container and NodePorts will be opened for external access: `31090`, `31091`, `31092`. All of these ports should
be reachable from any host to NodePorts are exposed because Kubernetes routes each NodePort from entry node
to pod/container listening on the same port (e.g. `31091`).

The `external.servicePort` at each external access service (one such service per pod) is a relay toward
the a `containerPort` with a number matching its respective `NodePort`. The range of NodePorts is set, but
should not actually listen, on all Kafka pods in the StatefulSet. As any given pod will listen only one
such port at a time, setting the range at every Kafka pod is a reasonably safe configuration.

#### Example values.yml for external service type NodePort

The + lines are with the updated values.

```bash
 external:
-  enabled: false
+  enabled: true
   # type can be either NodePort or LoadBalancer
   type: NodePort
   # annotations:
@@ -170,14 +170,14 @@ configurationOverrides:
   ##
   ## Setting "advertised.listeners" here appends to "PLAINTEXT://${POD_IP}:9092,", ensure you update the domain
   ## If external service type is Nodeport:
-  # "advertised.listeners": |-
-  #   EXTERNAL://kafka.cluster.local:$((31090 + ${KAFKA_NODE_ID}))
+  "advertised.listeners": |-
+    EXTERNAL://kafka.cluster.local:$((31090 + ${KAFKA_NODE_ID}))
   ## If external service type is LoadBalancer and distinct is true:
   # "advertised.listeners": |-
   #   EXTERNAL://kafka-$((${KAFKA_NODE_ID})).cluster.local:19092
   ## If external service type is LoadBalancer and distinct is false:
   # "advertised.listeners": |-
   #   EXTERNAL://EXTERNAL://${LOAD_BALANCER_IP}:31090
   ## Uncomment to define the EXTERNAL Listener protocol
-  # "listener.security.protocol.map": |-
-  #   PLAINTEXT:PLAINTEXT,EXTERNAL:PLAINTEXT
+  "listener.security.protocol.map": |-
+    PLAINTEXT:PLAINTEXT,EXTERNAL:PLAINTEXT

$ kafkacat -b kafka.cluster.local:31090 -L
Metadata for all topics (from broker 0: kafka.cluster.local:31090/0):
 3 brokers:
  broker 2 at kafka.cluster.local:31092
  broker 1 at kafka.cluster.local:31091
  broker 0 at kafka.cluster.local:31090
 0 topics:

$ kafkacat -b kafka.cluster.local:31090 -P -t test1 -p 0
msg01 from external producer to topic test1

$ kafkacat -b kafka.cluster.local:31090 -C -t test1 -p 0
msg01 from external producer to topic test1
```

### LoadBalancer External Service Type

The load balancer external service type differs from the node port type by routing to the `external.servicePort` specified in the service for each statefulset container (if `external.distinct` is set). If `external.distinct` is false, `external.servicePort` is unused and will be set to the sum of `external.firstListenerPort` and the replica number.  It is important to note that `external.firstListenerPort` does not have to be within the configured node port range for the cluster, however a node port will be allocated.

#### Example values.yml and DNS setup for external service type LoadBalancer with external.distinct: true

The + lines are with the updated values.

```bash
 external:
-  enabled: false
+  enabled: true
   # type can be either NodePort or LoadBalancer
-  type: NodePort
+  type: LoadBalancer
   # annotations:
   #  service.beta.kubernetes.io/openstack-internal-load-balancer: "true"
   dns:
@@ -138,10 +138,10 @@ external:
   # If using external service type LoadBalancer and external dns, set distinct to true below.
   # This creates an A record for each statefulset pod/broker. You should then map the
   # A record of the broker to the EXTERNAL IP given by the LoadBalancer in your DNS server.
-  distinct: false
+  distinct: true
   servicePort: 19092
   firstListenerPort: 31090
-  domain: cluster.local
+  domain: example.com
   loadBalancerIP: []
   init:
     image: "lwolf/kubectl_deployer"
@@ -173,11 +173,11 @@ configurationOverrides:
   # "advertised.listeners": |-
   #   EXTERNAL://kafka.cluster.local:$((31090 + ${KAFKA_NODE_ID}))
   ## If external service type is LoadBalancer and distinct is true:
-  # "advertised.listeners": |-
-  #   EXTERNAL://kafka-$((${KAFKA_NODE_ID})).cluster.local:19092
+  "advertised.listeners": |-
+    EXTERNAL://kafka-$((${KAFKA_NODE_ID})).example.com:19092
   ## Uncomment to define the EXTERNAL Listener protocol
-  # "listener.security.protocol.map": |-
-  #   PLAINTEXT:PLAINTEXT,EXTERNAL:PLAINTEXT
+  "listener.security.protocol.map": |-
+    PLAINTEXT:PLAINTEXT,EXTERNAL:PLAINTEXT

$ kubectl -n kafka get svc
NAME                       TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)                      AGE
kafka                      ClusterIP      10.39.241.217   <none>           9092/TCP                     2m39s
kafka-0-external           LoadBalancer   10.39.242.45    35.200.238.174   19092:30108/TCP              2m39s
kafka-1-external           LoadBalancer   10.39.241.90    35.244.44.162    19092:30582/TCP              2m39s
kafka-2-external           LoadBalancer   10.39.243.160   35.200.149.80    19092:30539/TCP              2m39s
kafka-headless             ClusterIP      None            <none>           9092/TCP                     2m39s

DNS A record entries:
kafka-0.example.com A record 35.200.238.174 TTL 60sec
kafka-1.example.com A record 35.244.44.162 TTL 60sec
kafka-2.example.com A record 35.200.149.80 TTL 60sec

$ ping kafka-0.example.com
PING kafka-0.example.com (35.200.238.174): 56 data bytes

$ kafkacat -b kafka-0.example.com:19092 -L
Metadata for all topics (from broker 0: kafka-0.example.com:19092/0):
 3 brokers:
  broker 2 at kafka-2.example.com:19092
  broker 1 at kafka-1.example.com:19092
  broker 0 at kafka-0.example.com:19092
 0 topics:

$ kafkacat -b kafka-0.example.com:19092 -P -t gkeTest -p 0
msg02 for topic gkeTest

$ kafkacat -b kafka-0.example.com:19092 -C -t gkeTest -p 0
msg02 for topic gkeTest
```

#### Example values.yml and DNS setup for external service type LoadBalancer with external.distinct: false

The + lines are with the updated values.

```bash
 external:
-  enabled: false
+  enabled: true
   # type can be either NodePort or LoadBalancer
-  type: NodePort
+  type: LoadBalancer
   # annotations:
   #  service.beta.kubernetes.io/openstack-internal-load-balancer: "true"
   dns:
@@ -138,10 +138,10 @@ external:
   distinct: false
   servicePort: 19092
   firstListenerPort: 31090
   domain: cluster.local
   loadBalancerIP: [35.200.238.174,35.244.44.162,35.200.149.80]
   init:
     image: "lwolf/kubectl_deployer"
@@ -173,11 +173,11 @@ configurationOverrides:
   # "advertised.listeners": |-
   #   EXTERNAL://kafka.cluster.local:$((31090 + ${KAFKA_NODE_ID}))
   ## If external service type is LoadBalancer and distinct is true:
-  # "advertised.listeners": |-
-  #   EXTERNAL://kafka-$((${KAFKA_NODE_ID})).cluster.local:19092
+  "advertised.listeners": |-
+    EXTERNAL://${LOAD_BALANCER_IP}:31090
   ## Uncomment to define the EXTERNAL Listener protocol
-  # "listener.security.protocol.map": |-
-  #   PLAINTEXT:PLAINTEXT,EXTERNAL:PLAINTEXT
+  "listener.security.protocol.map": |-
+    PLAINTEXT:PLAINTEXT,EXTERNAL:PLAINTEXT

$ kubectl -n kafka get svc
NAME                       TYPE           CLUSTER-IP      EXTERNAL-IP      PORT(S)                      AGE
kafka                      ClusterIP      10.39.241.217   <none>           9092/TCP                     2m39s
kafka-0-external           LoadBalancer   10.39.242.45    35.200.238.174   31090:30108/TCP              2m39s
kafka-1-external           LoadBalancer   10.39.241.90    35.244.44.162    31090:30582/TCP              2m39s
kafka-2-external           LoadBalancer   10.39.243.160   35.200.149.80    31090:30539/TCP              2m39s
kafka-headless             ClusterIP      None            <none>           9092/TCP                     2m39s

$ kafkacat -b 35.200.238.174:31090 -L
Metadata for all topics (from broker 0: 35.200.238.174:31090/0):
 3 brokers:
  broker 2 at 35.200.149.80:31090
  broker 1 at 35.244.44.162:31090
  broker 0 at 35.200.238.174:31090
 0 topics:

$ kafkacat -b 35.200.238.174:31090 -P -t gkeTest -p 0
msg02 for topic gkeTest

$ kafkacat -b 35.200.238.174:31090 -C -t gkeTest -p 0
msg02 for topic gkeTest
```

## Known Limitations

* Only supports storage options that have backends for persistent volume claims (tested mostly on AWS)
* KAFKA_PORT will be created as an envvar and brokers will fail to start when there is a service named `kafka` in the same namespace. We work around this be unsetting that envvar `unset KAFKA_PORT`.

[brokerconfigs]: https://kafka.apache.org/documentation/#brokerconfigs

## Prometheus Stats

### Prometheus vs Prometheus Operator

Standard Prometheus is the default monitoring option for this chart. This chart also supports the CoreOS Prometheus Operator,
which can provide additional functionality like automatically updating Prometheus and Alert Manager configuration. If you are
interested in installing the Prometheus Operator please see the [CoreOS repository](https://github.com/coreos/prometheus-operator/tree/master/helm) for more information or
read through the [CoreOS blog post introducing the Prometheus Operator](https://coreos.com/blog/the-prometheus-operator.html)

### JMX Exporter

The majority of Kafka statistics are provided via JMX and are exposed via the [Prometheus JMX Exporter](https://github.com/prometheus/jmx_exporter).

The JMX Exporter is a general purpose prometheus provider which is intended for use with any Java application. Because of this, it produces a number of statistics which
may not be of interest. To help in reducing these statistics to their relevant components we have created a curated whitelist `whitelistObjectNames` for the JMX exporter.
This whitelist may be modified or removed via the values configuration.

To accommodate compatibility with the Prometheus metrics, this chart performs transformations of raw JMX metrics. For example, broker names and topics names are incorporated
into the metric name instead of becoming a label. If you are curious to learn more about any default transformations to the chart metrics, please have reference the [configmap template](https://github.com/kubernetes/charts/blob/master/incubator/kafka/templates/jmx-configmap.yaml).

### Kafka Exporter

The [Kafka Exporter](https://github.com/danielqsj/kafka_exporter) is a complementary metrics exporter to the JMX Exporter. The Kafka Exporter provides additional statistics on Kafka Consumer Groups.
