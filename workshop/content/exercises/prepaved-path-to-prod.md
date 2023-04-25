To handle the more complex deployment and operations of modern applications, there is a need for a culture change towards **DevSecOps**, a buzzword for improved collaboration between developers, security, and operations teams.
This collaboration should be **supported by automated processes**, like a self-service for developers to get access to the tools they need.

The automated process of testing applications and deploying them into production is called **Continuous Integration** and **Continuous Delivery** (CI/CD). 

The CI/CD tools universe is always in flux. 
![Popular CI/CD tools](../images/ci-cd-tools.png)
###### Challenges of most of the current CI/CD Tools
- They use an **orchestration model** where the orchestrator executes, monitors, and manages each of the steps of the path to production **synchronously**. If for example a path to production has a vulnerability scanning step, and a new CVE should arise, the only way to scan the code for it would be to trigger the orchestrator to initiate the scanning step or a new run through the supply chain.
- **No Separation of concerns** between the users and authors of the pipeline.
- **Different path to production for each of the applications**. Even if all the pipelines are based on one template, it's hard to update all of them if the template changes.
- The **developer experience is lacking**.

###### Introducing Cartographer - A Supply Chain Choreographer for Kubernetes
![Cartographer - A Supply Chain Choreographer for Kubernetes](images/cartographer-logo.png)

VMware Tanzu Application Platform uses the open-source Cartographer that allows developers to focus on delivering value to their users and provides platform teams the assurance that all code in production has passed through all the steps of a pre-approved paths to production.

```dashboard:open-url
url: https://cartographer.sh
```

Each pre-approved supply chain creates a paved road to production that allows developers to focus on delivering value to their users and provides App Operators the assurance that all code in production has passed through all the steps of an approved workflow.

##### Design and Philosophy

Cartographer **allows operators** via the **Supply Chain** abstraction **to define all of the steps** that an application must go through to create an image and Kubernetes configuration. 

**Contrary to many other Kubernetes native workflow tools** that already exist in the market, **Cartographer does not “run” any of the objects themselves**. Instead, it monitors the execution of each resource and templates the following resource in the supply chain after a given resource has completed execution and updated its status.

###### Choreography vs Orchestration

In the **orchestration** model, which is used by most of the current CI/CD tools like Jenkins or Tekton, an **orchestrator executes, monitors, and manages each of the steps** of the path to production. The CI stage, or any others, could not function independently from the orchestrator. In the case of a path to production with a vulnerability scanning step, if a new CVE should arise, the only way to scan the code for it would be to trigger the orchestrator to initiate the scanning step or a new run through the supply chain.
![](images/orchestrator.png)

In the **choreography** model, each step of the path to production and the tool required for that **step knows nothing about the next step**. It is **responsible for receiving a signal that it must perform some work, completing it, and signaling that it has finished**. In the same case as above, with a pipeline that has a vulnerability scanner, if there is a new CVE, the vulnerability scanner would know about it and trigger a new scan. When the scan is complete, the vulnerability scanner will send a message indicating that scanning is complete.
![](images/choreographer.png)
Because **steps of the path to production are rarely synchronous**, for example, if a new CVE comes up, someone clicks the button on a build, and so on, choreography is a natural choice as a workflow engine. **Flexibility and the ability to swap steps of the path to production is also of extreme importance**.

A more detailed explanation is available here:
```dashboard:open-url
url: https://tanzu.vmware.com/developer/guides/supply-chain-choreography/
```

###### Separation of Concerns
While the **supply chain is operator** facing, Cartographer also provides an **abstraction for developers** called **Workloads**. Workloads allow developers to create application specifications such as the location of their repository, environment variables, and service claims.

###### Reusable CI/CD
By design, **a supply chain can be used by many workloads of a specific type, like any web application**. This allows an operator to specify the steps in the path to production a single time and for developers to specify their applications independently but for each to use the same path to production. The intent is that developers are able to focus on providing value for their users and can reach production quickly and easily while providing peace of mind for app operators, who are ensured that each application has passed through the steps of the path to production that they've defined.
![Cartographer Diagram](images/cartographer.png)

To enable app operators to consistently apply runtime configurations to fleets of workloads of a specific type implemented in different technologies, **Convention Service** is another component of TAP that is not yet available as OSS. 
```dashboard:open-url
url: https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-cartographer-conventions-about.html
```

###### Kubernetes Resource Interoperability
With Cartographer, it's possible to choreograph both Kubernetes and non-Kubernetes resources within the same supply chain via **integrations to existing CI/CD pipelines** like Tekton by using the **Runnable Custom Resource Definition (CRD)**.

###### The Core of VMware Tanzu Application Platform

TAP provides a **full integration of all of its components via out of the box Supply Chains** that can be customized for customers' processes and tools.

Let's now explore the two fundamental resources that an operator deploys, **Supply Chains** and **Templates**, and how these interact with the resource a developer deploys, the **Workload**. 
We'll do this hands-on with an example of a simple supply chain that watches a Git repository for changes, builds a container image, and deploys it to the cluster.




