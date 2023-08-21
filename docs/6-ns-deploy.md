# Deploying NetCandy Store Overview

In this section we will deploy the NetCandy Store application using `helm`. You can deliver your Windows workloads in the same way you deliver your Linux workloads. Since everything is just YAML, the workflow is the same. Whether that be via Helm, an Operator, or via Ansible.


## Running a Mixed Linux/Windows Container Workload.

With Windows Containers support for OpenShift; You also have the ability to run application stacks of mixed workloads. This gives you the ability to run an application stack consisting of both Linx and Windows Containers.

In this section, we will show how you can run Windows workloads that work together with Linux workloads.

You will be deploying a sample application stack that delivers an eCommerce site, The NetCandy Store. This application is built using Windows Containers working together with Linux Containers.

IMAGE

This application consists of:

- Windows Container running a .NET v4 frontend, which is consuming a backend service.

- Linux Container running a .NET Core backend service, which is using a database.

- Linux Container running a MSSql database.

We will be using a helm chart to deploy the sample application. In order to successfully deploy the application stack, make sure you’re kubeadmin.

Next add the Red Hat Developer Demos Helm repository.


```shell
helm repo add redhat-demos https://redhat-developer-demos.github.io/helm-repo
helm repo update
```

Create the namespace for netcandystore.

```shell
oc create namespace netcandystore
```

Next we will use this command below to create a Kubernetes resource with specific security restrictions and context constraints within the OpenShift cluster.

```shell
oc create -f windows-containers-quickstart/support/restrictedfsgroupscc.yaml
```

Next, we’ll allow a specific group of service accounts (in this case, those related to Microsoft SQL Server) to follow the strict security rules defined by the "restrictedfsgroup" Security Context Constraints in the OpenShift system.

```shell
oc adm policy add-scc-to-group restrictedfsgroup system:serviceaccounts:mssql
```

With the two variables exported, and the helm repo added, you can install the application stack using the helm cli.

```shell
helm install ncs --namespace netcandystore \
--timeout=1200s \
redhat-demos/netcandystore
```

Note: Note that the --timeout=1200s is needed because the default timeout for helm is 5 minutes and, in most cases, the Windows container image will take longer than that to download.

This will look like it’s "hanging" or "stuck". It’s not! What’s happening is that the image is getting pulled into the Windows node. As stated before, Windows containers can be very large, so it might take some time.

After some time, you should see something like the following return.

```shell
NAME: ncs
LAST DEPLOYED: Sun Mar 28 00:16:05 2021
NAMESPACE: netcandystore
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
1. Get the application URL by running these commands:
oc get route netcandystore -n netcandystore -o jsonpath='{.spec.host}{"\n"}'

2. NOTE: The Windows container deployed only supports the following OS:

Windows Version:
=============
Windows Server 2019 Release 1809

Build Version:
=============

Major  Minor  Build  Revision
-----  -----  -----  --------
10     0      17763  0
```
