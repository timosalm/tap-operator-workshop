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

A `ClusterSupplyChain` is Cartographer's CRD to define a supply chain. By exporting the OOTB Supply Chain with Testing and Scanning from the cluster, we can have a look at it in the local IDE.
```execute
kubectl eksporter ClusterSupplyChain source-test-scan-to-url
```



We'll do this hands-on with an example of a simple supply chain that watches a Git repository for changes, builds a container image, and deploys it to the cluster.