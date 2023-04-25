To handle the more complex deployment and operations of modern applications, there is a need for a culture change towards **DevSecOps**, a buzzword for improved collaboration between developers, security, and operations teams.
This collaboration should be **supported by automated processes**, like a self-service for developers to get access to the tools they need.

The automated process of testing applications and deploying them into production is called **Continuous Integration** and **Continuous Delivery** (CI/CD). 

The CI/CD tools universe is always in flux. 
![Popular CI/CD tools](../images/ci-cd-tools.png)
###### Challenges of most of the current CI/CD Tools
They use an **orchestration model** where the orchestrator executes, monitors, and manages each of the steps of the path to production **synchronously**. If for example a path to production has a vulnerability scanning step, and a new CVE should arise, the only way to scan the code for it would be to trigger the orchestrator to initiate the scanning step or a new run through the supply chain.


**No Separation of concerns** between the users and authors of the pipeline.


**Different path to production for each of the applications**. Even if all the pipelines are based on one template, it's hard to update all of them if the template changes.


The **developer experience is lacking**.



