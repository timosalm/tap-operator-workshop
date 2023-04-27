##### Carvel tools

For the installation and upgrades, VMware Tanzu Application Platform is heavily using the **Carvel** tools and especially **kapp-controller's package management capabilities**.
```dashboard:open-url
url: https://carvel.dev
```
```dashboard:open-url
https://carvel.dev/kapp-controller/docs/v0.43.2/packaging/
```

Here is a diagram that shows the relationship of all the CRDs for package management with kapp-controller.
![**kapp-controller's** package management capabilities](../images/carvel-package-management.png)

Let's use the tanzu CLI to get a more human readable output than by directly interacting with the Kubernetes resources to get an idea how it works. The tanzu CLI can also be used to apply all of those resources.

A **PackageRepository** is a collection of **Packages** and their metadata. 
```terminal:execute
command: tanzu package repository get tanzu-tap-repository -n tap-install
clear: true
```
After adding it to the cluster, we can discover all the packages it provides to be installed in the cluster.
```terminal:execute
command: tanzu package available list -n tap-install
clear: true
```

Those Packages can then be installed in the cluster by using the **PackageInstall** CR.
```terminal:execute
command: tanzu package installed get tap -n tap-install
clear: true
```
The "tap" Package here, is special because it applies PackageInstall of all the other components for an easy installation, upgrade and uninstallation experience.

Advanced workshops for the installation of TAP are available on Tanzu Acandemy.
```dashboard:open-url
url: https://tanzu.academy/paths
```

##### GitOps
Since TAP 1.5 it's now possible to also install VMware Tanzu Application Platform via GitOps.
```dashboard:open-url
https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.5/tap/install-gitops-intro.html
```
The auto provisioning of namespaces with required resources like scan policies is also possible via GitOps.
```dashboard:open-url
https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.5/tap/namespace-provisioner-about.html
```

It you use GitOps for the installation, it probably also makes sense to manage the other resources that have to be applied to cluster via GitOps, like for example the workloads, supply chains, app accelerators, etc.

#### Authentication and authorization
There are several levels and components an Authentication provider has to be integrated into TAP for authentication and authorization.

As most of the capabilities of TAP are Kubernetes native, the first level is the role-based access control (RBAC) of the Kubernetes clusters. With Pinniped VMWare has create an OSS solution that not only works with TKG, but also with EKS, AKS, and GKE and supports OIDC, LDAP, and Microsoft AD.
```dashboard:open-url
https://pinniped.dev
```

The next integration point is TAP-GUI. **Backstage** is the underlying technology of TAP-GUI which supports a variety of Authentication providers. It still lacks fine-granular authorization controls which we are working on adding to TAP-GUI.

Last but not least we have we've a component called **Application Single Sign-On for VMware Tanzu** to secure access to applications running on TAP which supports OIDC, LDAP, and SAML.