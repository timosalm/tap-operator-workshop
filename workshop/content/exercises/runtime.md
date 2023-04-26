VMware Tanzu Application platform also provides several tools for the runtime of the application.

##### Serverless runtime

When you opened the URL of the running application in the browser you may have seen that TLS was configured and it took some time until you got a first response from the application.

Both are in a way features of our commercial **Cloud Native Runtimes for VMware Tanzu** (CNRs) which is a serverless application runtime for Kubernetes that is based on **Knative**.

Knative, is an open source community project which provides a simple, consistent layer over Kubernetes that solves common problems of deploying software, connecting disparate systems together, upgrading software, observing software, routing traffic, and scaling automatically. 
```dashboard:open-url
url: https://knative.dev/docs/
```

The major **subprojects of Knative** are Serving and Eventing.
- **Serving** supports deploying upgrading, routing, and scaling of stateless applications and functions 
- **Eventing** enables developers to use an event-driven architecture with serverless applications and is **out of scope of this workshop**

Let's have a look at the Knative Serving Service the supply chain has generated and deploy for us.
```terminal:execute
command: kubectl get kservice payment-service
clear: true
```
The output provides information about the status, the revision, and the url the application is exposed with.

By using the **kubectl tree plugin**, we can really see how **Knative Serving abstracts away a lot of those resources** we usually have to configure to get an application running like a deployment, service, ingress etc.
```terminal:execute
command: kubectl tree kservice payment-service | less
clear: true
```

It also provides **configurable auto scaling** and **scale to zero** which is the reason why you had to wait for some seconds after you first called your appliction. Other features are rollbacks, canary and blue-green deployment via revisions and traffic splitting.


##### Provisioning and consumption of backing services

VMware Tanzu Application Platform makes it easy as possible to discover, curate, consume, and manage backing services, such as databases, queues, and caches, across single or multi-cluster environments. 

This experience is made possible by using the **Services Toolkit** component. 




Other runtime components of VMware Tanzu Application Platform like **Application Live View, VMware Spring Cloud Gateway for Kubernetes, Application Configuration Service, Application Single Sign-On, and Contour will not be covered in this workshop**.


-----
**TODO**








Within the context of Tanzu Application Platform, one of the most important use cases is binding an application workload to a backing service such as a PostgreSQL database or a RabbitMQ queue. 
This use case is made possible by the [Service Binding Specification](https://github.com/k8s-service-bindings/spec) for Kubernetes. 

Let's first check whether the RabbitMQ cluster the ```sensors-publisher``` application is running in the workshop namespace.
```execute
kubectl get RabbitmqCluster -n dev-space
```
```execute
kubectl get deployments sensors-publisher -n dev-space
```

```execute
tanzu service instance list -owide --kubeconfig kubeconfig.yaml -n dev-space
```

We are then able to add the ServiceBinding configuration to our workload.
```editor:insert-value-into-yaml
file: workload.yaml
path: spec
value:
  serviceClaims:
    - name: rmq
      ref:
        apiVersion: rabbitmq.com/v1beta1
        kind: RabbitmqCluster
        name: rmq-1
```
```execute
tanzu apps workload update -f workload.yaml --kubeconfig kubeconfig.yaml
```

For both, the credentials that are required for the connection to the RabbitMQ cluster are injected as environment variables into the containers via a service binding.
```execute
kubectl get ServiceBinding -n dev-space
```
If we have a closer look at one of the ServiceBinding objects, we can see references to a ResourceClaim for the RabbitMQ Cluster and the Knative Serving Service of our application.
```execute
kubectl get ServiceBinding spring-sensors-rmq -n dev-space -o yaml | yq e '.spec' -
```
Additionally, the name of the Kubernetes Secret that includes the credentials for the RabbitMQ cluster is available in the `status.binding` field.
```execute
kubectl get ServiceBinding spring-sensors-rmq -n dev-space -o yaml | yq e '.status.binding' -
```
Behind the scenes, based on those Custom Resource Definitions objects, the Kubernetes Secret that includes the credentials will be mounted to the application containers as a volume.


 It's also supported to direct reference a Kubernetes Secret resources to enable developers to connect their application workloads to almost any backing service, including backing services that are running external to the platform and do not adhere to the Provisioned Service specifications.
 ```dashboard:open-url
url: {{ ENV_TAP_PRODUCT_DOCS_BASE_URL }}/GUID-getting-started.html#use-case-3--binding-an-application-to-a-service-running-outside-kubernetes-32
```