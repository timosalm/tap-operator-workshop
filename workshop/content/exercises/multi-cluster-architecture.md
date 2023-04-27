VMware Tanzu Application Platform supports a **single cluster installation** where all its components and the workloads run on, and also a **multi-cluter installation** of the following types of clusters:
- **Iterate clusters** (1 or more for each market) for "inner loop" development iteration. Developers connect to the Iterate Cluster via their IDE to rapidly iterate on new software features. 
- The **build cluster** (1 global or for each market) is responsible for taking a developer's source code commits and applying a supply chain that will produce a container image and Kubernetes manifests for deploying on **run clusters**.
- The **view cluster** (1 global) is designed to run the developer portal (TAP GUI), Learning Center, and API Portal. One benefit of having them on a separate cluster for us is that developers are able to discover all the applications in the different markets.
- Several **run clusters** for the different stages and markets that fetch the container image and Kubernetes resources created by the build cluster and run them as defined for each application.

To **simplify the installation experience**, TAP defines **pre-defined installation profiles** for each of the different installations/cluster types.

![Multicluster topology](../images/multicluster-diagram.jpg)

In the last section, you'll get an idea of the installation and day 2 experience VMware Tanzu Application Platform provides.