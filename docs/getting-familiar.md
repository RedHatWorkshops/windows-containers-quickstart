# Getting familiar with the Installation

In this module, we'll get familiar with the cluster and the install of the Windows Node. If you haven't done already, login to the bastion node provided by the RHPDS email.

```shell
$ ssh chernand-redhat.com@bastion.lax-e35b.sandbox886.opentlc.com
```

Make sure you become the `ec2-user` as well.

```shell
$ sudo su - ec2-user
```

## Windows Node

The Windows Node appears just like any other node on OpenShift.

```shell
$ oc get nodes
NAME                           STATUS   ROLES    AGE   VERSION
ip-10-0-138-9.ec2.internal     Ready    worker   11m   v1.21.1-1398+98073871f173ba
ip-10-0-143-175.ec2.internal   Ready    worker   62m   v1.21.1+9807387
ip-10-0-143-5.ec2.internal     Ready    master   73m   v1.21.1+9807387
ip-10-0-152-15.ec2.internal    Ready    worker   62m   v1.21.1+9807387
ip-10-0-154-20.ec2.internal    Ready    master   73m   v1.21.1+9807387
ip-10-0-160-21.ec2.internal    Ready    master   73m   v1.21.1+9807387
ip-10-0-162-168.ec2.internal   Ready    worker   62m   v1.21.1+9807387
```

This node is labeled, so you know which one is a windows node.

```shell
$ oc get nodes -l kubernetes.io/os=windows
NAME                         STATUS   ROLES    AGE   VERSION
ip-10-0-138-9.ec2.internal   Ready    worker   12m   v1.21.1-1398+98073871f173ba
```

You can see what version of the OS you're running with the `-o wide` option.

```shell
$ oc get nodes -l kubernetes.io/os=windows -o wide
NAME                         STATUS   ROLES    AGE   VERSION                       INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION    CONTAINER-RUNTIME
ip-10-0-138-9.ec2.internal   Ready    worker   12m   v1.21.1-1398+98073871f173ba   10.0.138.9    <none>        Windows Server 2019 Datacenter   10.0.17763.2237   docker://20.10.7
```

As you can see this is running Windows Server 2019 Datacenter, and the container runtime is docker.

This is installed/managed/controlled by the Windows Machine Config Operator (WMCO). We will explore in a bit.
