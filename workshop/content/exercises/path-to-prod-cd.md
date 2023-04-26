##### Image Provider

To be able to get all the benefits for our application Kubernetes provides, we have to containerize it.

The most obvious way to do this, is to write a Dockerfile, run `docker build` and push it to the container registry of our choice via `docker push`.

![](../images/dockerfile.png)

As you can see, in general it is relatively easy and requires little effort to containerize an application, but whether you should go into production with it, is another question, because it is hard to create an optimized and secure container image (or Dockerfile).

To improve the Docker image generation, **Buildpacks** were conceived by Heroku in 2011. Since then, they have been adopted by Cloud Foundry and other PaaS.
The new generation of buildpacks, the [Cloud Native Buildpacks](https://buildpacks.io), is an incubating project in the CNCF which was initiated by Pivotal and Heroku in 2018.

Cloud Native Buildpacks (CNBs) detect what is needed to compile and run an application based on the application's source code. 
The application is then compiled by the appropriate buildpack and a container image with best practices in mind is build with the runtime environment.

The biggest benefits of CNBs are increased security, minimized risk, and increased developer productivity because they don't need to care much about the details of how to build a container.

With all the benefits of Cloud Native Buildpacks, one of the **biggest challenges with container images still is to keep the operating system, used libraries, etc. up-to-date** in order to minimize attack vectors by CVEs.

With **VMware Tanzu Build Service (TBS)**, which is part of TAP and based on the open source [kpack](https://github.com/pivotal/kpack), it's possible **automatically recreate and push an updated container image to the target registry, if there is a new version of the buildpack or the base operating system available** (e.g. due to a CVE), a new container is automatically created and pushed to the target registry.
With our Supply Chain, it's then possible to deploy security patches automatically.
This fully automated update functionality of the base container stack is a big competitive advantage compared to other tools.

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

There is also a CLI for Kubernetes available for more human friendly output: [kp CLI](https://github.com/vmware-tanzu/kpack-cli) which you can try in the workshop environment

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

##### Config Provider, App Config, Service Bindings, Api Descriptors 

##### Config Writer 

##### Delivery