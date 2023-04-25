######## The Core of VMware Tanzu Application Platform

TAP provides a **full integration of all of its components via out of the box Supply Chains** that can be customized for customers' processes and tools.

Let's now explore the two fundamental resources that an operator deploys, **Supply Chains** and **Templates**, and how these interact with the resource a developer deploys, the **Workload**. 
We'll do this hands-on with an example of a simple supply chain that watches a Git repository for changes, builds a container image, and deploys it to the cluster.