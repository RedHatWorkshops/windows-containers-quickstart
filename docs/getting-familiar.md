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
NAME                                         STATUS   ROLES    AGE   VERSION
ip-10-0-128-87.us-east-2.compute.internal    Ready    worker   46h   v1.19.0+e465e66
ip-10-0-129-196.us-east-2.compute.internal   Ready    master   46h   v1.19.0+e465e66
ip-10-0-147-19.us-east-2.compute.internal    Ready    worker   45h   v1.19.0-rc.2.1023+f5121a6a6a02dd
ip-10-0-160-175.us-east-2.compute.internal   Ready    worker   46h   v1.19.0+e465e66
ip-10-0-187-68.us-east-2.compute.internal    Ready    master   46h   v1.19.0+e465e66
ip-10-0-220-109.us-east-2.compute.internal   Ready    master   46h   v1.19.0+e465e66
```

This node is labeled, so you know which one is a windows node.

```shell
$ oc get nodes -l kubernetes.io/os=windows
NAME                                        STATUS   ROLES    AGE   VERSION
ip-10-0-147-19.us-east-2.compute.internal   Ready    worker   46h   v1.19.0-rc.2.1023+f5121a6a6a02dd
```

You can see what version of the OS you're running with the `-o wide` option.

```shell
$ oc get nodes -l kubernetes.io/os=windows -o wide
NAME                                        STATUS   ROLES    AGE   VERSION                            INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION    CONTAINER-RUNTIME
ip-10-0-147-19.us-east-2.compute.internal   Ready    worker   46h   v1.19.0-rc.2.1023+f5121a6a6a02dd   10.0.147.19   <none>        Windows Server 2019 Datacenter   10.0.17763.1457   docker://19.3.11
```

As you can see this is running Windows Server 2019 Datacenter, and the container runtime is docker.

This is installed/managed/controlled by the Windows Machine Config Operator (WMCO). We will explore that in a separate module.
