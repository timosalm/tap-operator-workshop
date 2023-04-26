TAP supports the installation of all its component on one cluster.

For production deployments, VMware recommends a multi-cluter installation of two fully independent instances of Tanzu Application Platform. One instance for operators to conduct their own reliability tests, and the other instance hosts development, test, QA, and production environments for our different markets isolated by separate clusters.

The recommended multi-cluter installation of the following types of clusters:

Iterate Clusters (1 or more for each market) for "inner loop" development iteration. Developers connect to the Iterate Cluster via their IDE to rapidly iterate on new software features. The Iterate Cluster operates distinctly from the outer loop infrastructure. Each developer should be given their own namespace within the Iterate Cluster during their platform onboarding.
The Build Cluster (1 global or for each market) is responsible for taking a developer's source code commits and applying a supply chain that will produce a container image and Kubernetes manifests for deploying on a Run Cluster. The Kubernetes Build Cluster will see bursty workloads as each build or series of builds kicks off. The Build Cluster will see very high pod scheduling loads as these events happen. The amount of resources assigned to the Build Cluster will directly correlate to how quickly parallel builds are able to be completed.
The View Cluster (1 global) is designed to run the developer portal (TAP GUI), Learning Center, and API Portal. One benefit of having them on a separate cluster for us is, that developers are able to discover all the applications in the different markets.
Several Run Clusters for the different stages and markets that read the container image and Kubernetes resources created by the Build Cluster and runs them as defined for each application.



##### Single Cluster Installation

##### Multi Cluster Installation
![Multicluster topology](../images/multicluster-diagram.jpg)