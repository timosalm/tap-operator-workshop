There are several ways to apply a Workload to VMware Tanzu Application Platform, as Workloads are implemented as custom Kubernetes resources.

###### Applying a Workload directly to a Kubernetes cluster

If developers have access to a namespace in the Kubernetes cluster the supply chain is available, they can use the **tanzu CLI** as a higher abstraction to apply a Workload.
```
tanzu apps workload create -f workload.yaml
```
Instead of using a YAML file with the configurations, there are also flags for all of them available.
```
tanzu apps workload create sample --git-repo https://github.com/... --git-branch main --type web
```
The "kubectl" CLI can also be used to apply a custom Workload resource.
```
kubectl apply -f workload.yaml
```

###### Applying a Workload via GitOps (recommended)

The sample Workload for this workshop is applied via **GitOps** and available here:
```dashboard:open-url
url: https://github.com/timosalm/tap-operator-workshop/blob/main/samples/workload-gitops/workload.yaml
```

GitOps is an operational model that uses Git repositories as a single source of truth to version and store infrastructure configuration. The configuration is pulled continuously by tools like in this case [kapp-controller](https://carvel.dev/kapp-controller/) or [Flux](https://fluxcd.io) to ensure the infrastructure is correctly configured.

The benefit of using this operational model for the Workload is that **developers don't need access to the Kubernetes cluster**, and once a change is triggered in Git by a developer, it's applied to the environment with little or no involvement from operations.

Let's have a closer look at the sample Workload available in the GitOps repository in our local IDE.
```editor:select-matching-text
file: ~/samples/workload-gitops/workload.yaml
text: "name: payment-service"
```
As already mentioned, a **Workload is a Kubernetes custom resource definition (CRD) of Cartographer** that implements the interface for developers to provide configuration for an application's path to production.

In addition to the name of the Workload, there is also `app.kubernetes.io/part-of` label with the same value, which is used by for example the TAP GUI to match documentation with runtime resources.

The location of an application's source code can be configured via the `spec.source` field. Here, we are using a branch of a Git repository as a source to be able to implement a **continuous path to production** where every git commit to the codebase will trigger another execution of the supply chain, and developers only have to apply a Workload once if they start with a new application or microservice. 
For the to-be-deployed application, the Workload custom resource also provides configuration options for a **pre-built image in a registry** from e.g. an ISV via `spec.image`.

Other configuration options are available for resource constraints (`spec.limits`, `spec.requests`) and environment variables for the build resources in the supply chain (`spec.build.env`) and to be passed to the running application (`spec.env`).

Last but not least via (`.spec.params`), it's possible to override default values of the additional parameters that are used in the Supply Chain but not part of the official Workload specification.

There are more configuration options available which you can have a look at in the detailed specification here:
```dashboard:open-url
url: https://cartographer.sh/docs/v0.7.0/reference/workload/
```

The GitOps for the Workload is in our workshop implemented using Carvel's **kapp-controller** running in the cluster. kapp-controller is also used for the installation of VMware Tanzu Application Platform.
```dashboard:open-url
url: https://carvel.dev/kapp-controller/
```

The kapp-controller's [App](https://carvel.dev/kapp-controller/docs/v0.43.2/app-overview/) CRD is used to provide all necessary configuration to continuously fetch Workload configuration from the Git repository and apply it to the workshop's namespace.
```execute
kubectl get apps workload-gitops
```

Before moving on, let's check the current status of the applied Workload with the tanzu CLI.
```execute
tanzu apps workload get payment-service
```

To provide an even higher abstraction than applying the Workload configuration via GitOps for the developers, you could also create a **self-service portal for developers** on top of it via [VMware Aria Automation](https://www.vmware.com/products/aria-automation.html) or ServiceNow.

After having a look at the Workload as an interface for developers, in the next sections, we'll have a closer look at the operator-facing supply chains.
