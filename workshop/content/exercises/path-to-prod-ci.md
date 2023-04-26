
###### Source Provider

The first step in the path to production watches the in the Workload configured repository with the source code for new commits and makes the source code available for the following steps as an archive via HTTP. 

[Flux Source Controller](https://fluxcd.io/flux/components/source/) is used for this functionality, but as with any other tool we provide with TAP it can be easily replaced by an alternative.

To get an idea on how that is implemented, we'll export the related **ClusterSourceTemplate** and open it in the IDE.
```execute
kubectl eksporter ClusterSourceTemplate source-template > ~/exports/source-template.yaml
```
```editor:select-matching-text
file: ~/exports/source-template.yaml
text: "revisionPath"
after: 1
```
A ClusterSourceTemplate indicates how the supply chain could instantiate an object responsible for providing source code. All it cares about is whether the `spec.urlPath` and `spec.revisionPath` are passed in correctly from the templated object that implements the actual functionality we want to use as part of our path to production.

To define the templating of the Kubernetes resource that provides the implementation of the desired functionality, there are two options. Simple templates can be defined in `spec.template` and provide string interpolation in a `\$(...)\$` tag with jsonpath syntax.
As in our example Carvel's ytt can be used for more complex logic, such as conditionals or looping over collections (defined via `spec.ytt` in Templates).
Both options for templating provide a data structure that contains the configuration from the Workload, defined inputs for the resource and paramters in the ClusterSupplyChain.

```editor:select-matching-text
file: ~/exports/source-template.yaml
text: "kind: GitRepository"
before: 1
after: 14
```

In our case Flux Source Controller is also Kubernetes native and provides a CRD. A custom resource will be then stamped out / updated by Cartographer every time the Workload, an input or parameter changes.

There are two other custom resources defined for the templating (MavenArtifact and ImageRepository) which will be stamped out instead of the GitRepository based on the Workload configuration. 
The **MavenArtifact** can pull artifacts from existing Maven repositories for integration with existing CI systems, such as Jenkins. The **ImageRepository** consumes a container image containing source code to make it possible via the tanzu CLI to provide source code from a local directory such as, from a directory in the developer’s file system.

More information on templating with Cartographer can be found here:
```dashboard:open-url
url: https://cartographer.sh/docs/v0.7.0/templating/
```

You can view the **output of the Source Provider** step in TAP-GUI by clicking on the rectangle next to it displaying the first digits of the commit revision.

###### Source Tester
 
The Source Tester step executes uses by default [Tekton](https://tekton.dev) to run a Pipeline that runs tests part of the application's source code.
Depending on how much flexibility your developers need, they can define it for their applications or as the rest of the supply chain it will also be defined and provided by the operators. The pipeline can also be applied via GitOps, in our case there is already a very basic example that just works for Spring Boot applications using Maven applied to the cluster.
```execute
kubectl eksporter Pipeline --keep metadata.labels
```

To decouple the pipeline from the supply chain, it's not directly stamped out by a template or referenced by name and instead will be detected based on it's `apps.tanzu.vmware.com/pipeline: test` label.

The Pipeline will be execute by stamping out a `PipelineRun` custom resource which is contrast to for example the GitRepository an immutable resource. Which means the template has to create a new resource whenever the configuration changes.

For more information, you can have look here:
```dashboard:open-url
url: https://cartographer.sh/docs/v0.7.0/tutorials/lifecycle/
```

***This type of integration of Tekton into the Cartographer world is heavily used within the OOTB supply chains to integrate tools outside of Kubernetes.**

Let's now jump to TAP-GUI to view the logs of test run in the detail view of the Source Tester step.





