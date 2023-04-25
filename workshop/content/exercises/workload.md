There are several ways to apply a Workload to VMware Tanzu Application Platform as Workloads are implemented as a custom Kubernetes resources.

###### Applying a Workload directly to a Kubernetes cluster

If developers have access to a namespace in the Kubernetes cluster, the supply chain is available, they can use the **tanzu CLI** as a higher abstraction to apply a Workload.
```
tanzu apps workload create -f workload.yaml
```
Instead of using a YAML file with the configurations, there are also flags for all of them available.
```
tanzu apps workload create sample --git-repo https://github.com/... --git-branch main --type web
```
The "kubectl" CLI can also be used to apply a the custom Workload resource.
```
kubectl apply -f workload.yaml
```

###### Applying a Workload via GitOps (recommended)

The sample Workload for this workshop is applied via **GitOps** and available here:
```dashboard:open-url
url: https://github.com/tsalm-vmware/tap-operator-workshop/blob/main/samples/workload.yaml
```

GitOps is a operational model that uses Git repositories as a single source of truth to version and store infrastructure configuration. The configuration is pulled continously by tools like in this case [kapp-controller](https://carvel.dev/kapp-controller/) or [Flux](https://fluxcd.io) to ensure the infrastructure is correctly configured.

The benefit of using this operational model for the Workload is, that **developers don't need access to the Kubernetes cluster**, and once a change is triggered in Git by a developer, it's applied to the environment with little or no involvement from operations.

Let's have a closer look at the sample Workload avaiable in the GitOps repository in our local IDE.
```editor:open-file
file: ~/samples/workload.yaml
```
As already mentioned, a **Workload is a Kubernetes custom resource definition (CRD) of Cartographer** that implements the interface for developers to provide configuration for an application's path to production.

In addition to the name of the Workload ...
```editor:select-matching-text
file: ~/samples/workload.yaml
text: "name: payment-service"
```
... there is also `app.kubernetes.io/part-of` label with the same value, which is used by for example the TAP GUI to match documentation with runtime resources.
```editor:select-matching-text
file: ~/samples/workload.yaml
text: "app.kubernetes.io/part-of: payment-service
"
```







If developers have 


You can find a detailed specification here:


