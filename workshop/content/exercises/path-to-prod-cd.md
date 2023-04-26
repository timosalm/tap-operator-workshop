##### Image Provider

To be able to get all the benefits for our application Kubernetes provides, we have to containerize it.

The most obvious way to do this, is to write a Dockerfile, run `docker build` and push it to the container registry of our choice via `docker push`.

![](../images/dockerfile.png)

As you can see, in general it is relatively easy and requires little effort to containerize an application, but whether you should go into production with it, is another question, because it is hard to create an optimized and secure container image (or Dockerfile).

To improve the container image creation, **Buildpacks** were conceived by Heroku in 2011. Since then, they have been adopted by Cloud Foundry and other PaaS.
The new generation of buildpacks, the [Cloud Native Buildpacks](https://buildpacks.io), is an incubating project in the CNCF which was initiated by Pivotal (now part of VMware) and Heroku in 2018.

Cloud Native Buildpacks (CNBs) detect what is needed to compile and run an application based on the application's source code. 
The application is then compiled and packaged in a container image with best practices in mind by the appropriate buildpack.

The biggest benefits of CNBs are increased security, minimized risk, and increased developer productivity because they don't need to care much about the details of how to build a container.

With all the benefits of Cloud Native Buildpacks, one of the **biggest challenges with container images still is to keep the operating system, used libraries, etc. up-to-date** in order to minimize attack vectors by CVEs.

With **VMware Tanzu Build Service (TBS)**, which is part of TAP and based on the open source [kpack](https://github.com/pivotal/kpack), it's possible **automatically recreate and push an updated container image to the target registry, if there is a new version of the buildpack or the base operating system available** (e.g. due to a CVE).
With our Supply Chain, it's then possible to deploy security patches automatically.

In the details of the Image Provider step in **TAP-GUI**, you're able to see the **logs of the container build and the tag of the produced image**.
It also shows the reason for an image build. In this case it's due to our configuration change. As mentioned image builds can be also triggered if new operating system or buildpack versions are available.
This shows another time the benefit of Cartographer's asynchonous behavior.

Let's have a closer look at the resources running in the cluster.
The custom `Image` resource provides all configuration required for TBS to build and maintain a container image utilizing Cloud Native Buildpacks.
```execute
kubectl eksporter image.kpack.io
```

It references a **(Cluster)Builder** resource which allows granular control of how stacks of base images, buildpacks, and buildpack versions are utilized and updated.
```execute
kubectl eksporter clusterbuilder default
```

There is also the [kp CLI](https://github.com/vmware-tanzu/kpack-cli) available for more human friendly output which you can try in the workshop environment. 
Here are some sample commands and you can also trigger a new build via `kp trigger image payment-service` with the right priviledges.
```execute
kp image list
```
```execute
kp image status payment-service
```
```execute
kp build list payment-service
```

###### Container signing

TAP also provides optional container signing capabilites. **VMware Tanzu Build Service is able to sign containers** and the **Policy Controller** is a Kubernetes Admission Controller that allows operators to apply policies to verify signatures on container images before being admitted to a cluster.

The OSS used for this functionality is [cosign](https://docs.sigstore.dev/cosign/overview/).

###### Dockerfile-based builds

For those few use-cases no buildpack is yet available and the effort to build a custom one is to high, it's also possible to build a container based on a Dockerfile with TAP. Developer's have to specify the following parameter in their Workload configuration where the value references the path of the Dockerfile.
```
apiVersion: carto.run/v1alpha1
kind: Workload
...
spec:
  params:
  - name: dockerfile
    value: ./Dockerfile
...
```
For the building of container images from a Dockerfile without the need for running Docker inside a container, TAP uses the open-source tool [kaniko](https://github.com/GoogleContainerTools/kaniko).

##### Image Scanner

If you **have a closer look at the Image Scanner step in TAP-GUI** you can see that **different CVEs where found than with the source scanning**. 
There are several reason for that:
- The **container image includes the full stack** required to run the application. In this case the application, Tomcat application server, Java runtime environment, operating system, and additonal tools. 
- The container image also **includes all the dependencies** required to run the application. To reduce disc space and network traffic, those will usually not be committed to the version control system together with the sourcecode and instead defined in dependency management tools like Maven or npm and downloaded during the build process. Most of the **CVE scanners don't download the dependencies** for sourcecode scans, **which leds often to false positives or missed CVEs**, as they only compare what's defined in the definition file of the used dependency management tools (e.g. pom.xml or package.json) with CVE databases. Therefore, they are for example not aware of nested dependencies.

You may ask yourself whether there is still a value in source scans. The answer is yes, as **shifting security left in the path to production improves the productivity of developers**.

Due to the false positives it makes sense to have **different scan policies for source scanning and image scanning** which is supported by VMware Tanzu Application Platform but not implemented for this workshop.

Let's first another time **change our scan policy for demo purposes** to see our application running through the rest of the path to production and then have another look at the SBoM which should now include information about the full container stack.

```editor:select-matching-text
file: ~/samples/scan-policy.yaml
text: 'notAllowedSeverities := ["Critical", "High", "UnknownSeverity"]'
```

```editor:replace-text-selection
file: ~/samples/scan-policy.yaml
text: 'notAllowedSeverities := ["UnknownSeverity"]'
```
**Run the following command to apply the updated scan policy.**
```execute
kubectl apply -f ~/samples/scan-policy.yaml
```
If you **go back to TAP-GUI**, you should see that the **status of the source and image scan will change** and the container image will be passed to the next step.

###### Software bills of materials of the container image
Run the following command to get a human readable output of the SBoM.
```terminal:execute
command: |
  IMAGE_DIGEST=$(kubectl get imagescan payment-service -o jsonpath='{.spec.registry.image}'  | awk -F @ '{ print $2 }')
  tanzu insight image get --digest $IMAGE_DIGEST
clear: true
```
We can also change the **output format to common SBoM standards** like **SPDX and CycloneDX** which can be then used by tools that support them. 
SPDX defines more granular relationships between elements, which makes it more expressive but also more complex to define and work with.
```terminal:execute
command: tanzu insight image get --digest $IMAGE_DIGEST --output-format cyclonedx-xml
clear: true
```
```execute
tanzu insight image get --digest $IMAGE_DIGEST --output-format spdx-json
```

##### Config Provider, App Config, Service Bindings, Api Descriptors 

The steps between "Image Scanner" and "Config Writer" in the supply chain generate the YAML of all the Kubernetes resource required to run the application.

###### Config Provider

The Config Provider step uses the **Cartographer Conventions** component to provide a means for operators to express their knowledge about how applications can run on Kubernetes as a convention. It supports defining and applying conventions to pods. 

You can **define conventions** to target workloads by **using container image metadata**.
Conventions can use this information to only apply changes to the configuration of workloads when they match specific criteria (for example, Spring Boot or .Net apps, or Spring Boot v2.3+). Targeted conventions can ensure uniformity across specific workload types deployed on the cluster.

Conventions **can also be defined** to apply to workloads **without targeting container image metadata**. Examples of possible uses of this type of convention include appending a logging/metrics sidecar, adding environment variables, or adding cached volumes. 

With the current version on TAP, the following **out of the box conventions** are available with more to come in future versions.
```terminal:execute
command: kubectl get ClusterPodConvention
clear: true
```
- **Developer conventions** is a set of conventions that enable workloads to support live-update and debug operations
- **Spring Boot conventions** are smaller conventions applied to any Spring Boot application submitted to the supply chain. Most them either modify or add properties to the environment variable `JAVA_TOOL_OPTIONS` like for example to configure graceful shutdown and the default port to 8080 
- **Application Live View conventions** help to identify pods that are enabled for Application Live View. The metadata labels also tell the Application Live View connector what kind of app it is, and on which port the actuators are accessible for Application Live View.

The conditional criteria governing the application of a convention is customizable and can be based on the evaluation of a custom Kubernetes resource called **PodIntent**.
```terminal:execute
command: kubectl get PodIntent -o yaml
clear: true
```
In `.status.template.spec` you can see information about the generated Pod template. The `conventions.carto.run/applied-conventions` annotation in `.status.template.metadata.annotation` lists all the applied conventions.


##### Config Writer 

##### Delivery