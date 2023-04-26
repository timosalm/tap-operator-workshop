Implementing a secure software supply chain is integral to securing software development and accelerating your DevSecOps capabilities.

VMware Tanzu Application Platform provides a **full integration of all of its components via out of the box supply chains** that can be customized for your processes and tools.

Let's now explore them to get an understanding of the two fundamental resources an operator deploys - **Supply Chains** and **Templates** - and how these interact with the **Workload** resource a developer deploys. Additionally, you'll also learn about all the components TAP provides relevant for the path to production.

#### Sample Supply Chains of VMware Tanzu Application Platform

TAP provides three out of the box (OOTB) supply chains that can be customized for your processes and tools.

##### OOTB Supply Chain Basic
![OOTB Supply Chain Basic](../images/sc-basic.png)
Capabilities of this supply chain: 
- Monitors a repository that is identified in the developer’s Workload configuration
- Creates a new container image out of source code
- Generates the Kubernetes resources for the delpoyment of the application as YAML and applies predefined conventions to them
- Deploys the application to the cluster

##### OOTB Supply Chain with Testing
![OOTB Supply Chain with Testing](../images/sc-testing.png)
Additional capabilities of this supply chain: 
- Runs application tests using a Tekton or Jenkins pipeline

##### OOTB Supply Chain with Testing and Scanning
![OOTB Supply Chain with Testing+Scanning](../images/sc-testing-scanning.png)
Additional capabilities of this supply chain: 
- The application source code is scanned for vulnerabilities
- The container image is scanned for vulnerabilities

All of the OOTB supply chains also support a prebuilt application container image as an input instead of source code. In this case only the steps after the container image creation will be executed (e.g. image scanning, Kubernetes resources YAML generation, Deployment).

As the OOTB Supply Chain with Testing and Scanning provides the most capabilities, we'll now have a closer look at the implementation and the different tools that provide all of them.

A `ClusterSupplyChain` is Cartographer's CRD to define a supply chain. We'll now export the OOTB Supply Chain with Testing and Scanning from the cluster to view in the workshop's IDE.
```execute
kubectl eksporter ClusterSupplyChain source-test-scan-to-url > supply-chain.yaml
```
```editor:open-file
file: ~/supply-chain.yaml
```
Any changes made to this custom resource in the cluster will immediately affect the path to production of the Workloads configured for it. Due to the asynchronouns behavior of Cartographer only those steps that are affected by the change and related outputs will be triggered. 

The first part of our supply chain resource configures parameters via `.spec.params`. They follow a hierarchy and default values (`.spec.params[*].default`) can be overriden by the Workload's `.spec.params` in constrast to those set with `.spec.params[*].value`.

The `.spec.resources` section is an unordered list of steps (or resources) of our supply chain even if they are ordered in this example for readability.

```editor:select-matching-text
file: ~/supply-chain.yaml
text: "- name: source-tester"
after: 6
```

The implementation of those resources are specified via **Templates**. Each **template acts as a wrapper for existing Kubernetes resources** and allows them to be used with Cartographer. This way, Cartographer doesn’t care what tools are used under the hood. There are currently four different types of templates that can be use in a Cartographer supply chain: ClusterSourceTemplate (like in this example), ClusterImageTemplate, ClusterConfigTemplate, and the generic ClusterTemplate.

The first three of the **templates define a contract for the output** to be consumbed by other resources. A ClusterTemplate instructs the supply chain to instantiate a Kubernetes object that has no outputs to be supplied to other objects in the chain.

We can also see in the example how inputs from other resources can be defined. In this case the resource is listening on outputs from the `source-provider`'s ClusterSourceTemplate. Image inputs can be defined via `.spec.resources[*].images` and  Config inputs `.spec.resources[*].configs`.

```editor:select-matching-text
file: ~/supply-chain.yaml
text: "apps.tanzu.vmware.com/has-tests: 'true'"
before: 1
after: 8
```

Last but not least we have the configuration for matching of Workloads. Those Workloads that match `spec.selector`, `spec.selectorMatchExpressions`, and/or `spec.selectorMatchFields` will use the supply chain as path to production.

We'll know have a closer look at all the different steps of the supply chain and the capabilities of tools they're implemented with. To make it easier to follow, I recommend to have a look at TAP-GUI for a visualization of the supply chain.
```dashboard:open-url
url: https://tap-gui.{{ ENV_TAP_INGRESS }}/supply-chain/host/{{ session_namespace }}/payment-service
```