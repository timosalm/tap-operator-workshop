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
url: https://github.com/tsalm-vmware/tap-operator-workshop/blob/main/samples/workload-gitops/workload.yaml
```

GitOps is a operational model that uses Git repositories as a single source of truth to version and store infrastructure configuration. The configuration is pulled continously by tools like in this case [kapp-controller](https://carvel.dev/kapp-controller/) or [Flux](https://fluxcd.io) to ensure the infrastructure is correctly configured.

The benefit of using this operational model for the Workload is, that **developers don't need access to the Kubernetes cluster**, and once a change is triggered in Git by a developer, it's applied to the environment with little or no involvement from operations.

Let's have a closer look at the sample Workload avaiable in the GitOps repository in our local IDE.
```editor:select-matching-text
file: ~/samples/workload-gitops/workload.yaml
text: "name: payment-service"
```
As already mentioned, a **Workload is a Kubernetes custom resource definition (CRD) of Cartographer** that implements the interface for developers to provide configuration for an application's path to production.

In addition to the name of the Workload, there is also `app.kubernetes.io/part-of` label with the same value, which is used by for example the TAP GUI to match documentation with runtime resources.
```editor:select-matching-text
file: ~/samples/workload-gitops/workload.yaml
text: "app.kubernetes.io/part-of: payment-service"
```

**TODO**

There are more configuration options available like for example a container image or maven artifacts available. A detailed specification is available here:
```dashboard:open-url
url: https://cartographer.sh/docs/v0.7.0/reference/workload/
```

The GitOps for the Workload is in our workshop implemented using Carvel's **kapp-controller** running in the cluster. kapp-controller is also used for the installation of VMware Tanzu Application Platform.
```dashboard:open-url
url: https://carvel.dev/kapp-controller/
```

The kapp-controller's `App` CRD is used to provide all neccesary configuration to continuously fetch Workload configuration from the Git repository and apply it to the workshops namespace.
```execute
kubectl describe apps workload-gitops
```

Let's check the current status of the applied Workload with the tanzu CLI before moving on.
```execute
tanzu apps workload get payment-service
```

To provide an even higher abstraction than applying the Workload configuration via GitOps for the developers, you could also create a **self-service portal for developers** on top of it via [VMware Aria Automation](https://www.vmware.com/products/aria-automation.html) or ServiceNow.
