# Working With the Windows Machine

The Windows Node is installed and managed by the Machine Config Operator. In this module you'll explore the MachineSet as it pertains to the Windows Node.

## Windows MachineSet

The Windows Node was installed using a MachineSet

```shell
$ oc get machinesets -n openshift-machine-api | grep windows
cluster-lax-e35b-tmk54-windows-us-east-2a   1         1         1       1           46h
```

Go ahead and take a look at the details

```shell
oc get machinesets -n openshift-machine-api cluster-lax-e35b-tmk54-windows-us-east-2a -o yaml
```

This is the same format as a RHCOS MachineSet. Take a look at the machine it creates.

```shell
$ oc get machines -n openshift-machine-api  -l machine.openshift.io/os-id=Windows
NAME                                              PHASE     TYPE        REGION      ZONE         AGE
cluster-lax-e35b-tmk54-windows-us-east-2a-nzqdq   Running   m5a.large   us-east-2   us-east-2a   47h
```

This will correspond to a node on the platform.

```shell
$ oc get nodes -l kubernetes.io/os=windows
NAME                                        STATUS   ROLES    AGE   VERSION
ip-10-0-147-19.us-east-2.compute.internal   Ready    worker   47h   v1.19.0-rc.2.1023+f5121a6a6a02dd
```

Note, that this node has a taint on it, so you need to keep that in mind when trying to deploy workloads on the Windows Node.

```shell
$ oc describe node ip-10-0-147-19.us-east-2.compute.internal | grep -i Taint
Taints:             os=Windows:NoSchedule
```

You can scale this node like ANY other node! Via the MachineSet.

```shell
$ oc scale machineset cluster-lax-e35b-tmk54-windows-us-east-2a --replicas=2 -n openshift-machine-api
```

This creates another Windows machine

```shell
$ oc get machines -n openshift-machine-api  -l machine.openshift.io/os-id=Windows
NAME                                              PHASE         TYPE        REGION      ZONE         AGE
cluster-lax-e35b-tmk54-windows-us-east-2a-nclvp   Provisioned   m5a.large   us-east-2   us-east-2a   38s
cluster-lax-e35b-tmk54-windows-us-east-2a-nzqdq   Running       m5a.large   us-east-2   us-east-2a   47h
```

Adding a node can take some time (up to 10 min). So keep a watch on this

```shell
watch "oc get nodes -l kubernetes.io/os=windows"
```

After a while you should have two Windows nodes

```shell
$ oc get nodes -l kubernetes.io/os=windows
NAME                                         STATUS   ROLES    AGE     VERSION
ip-10-0-147-171.us-east-2.compute.internal   Ready    worker   5m33s   v1.19.0-rc.2.1023+f5121a6a6a02dd
ip-10-0-147-19.us-east-2.compute.internal    Ready    worker   47h     v1.19.0-rc.2.1023+f5121a6a6a02dd
```

Delete a node the same way, by scaling it down.

```shell
oc scale machineset cluster-lax-e35b-tmk54-windows-us-east-2a --replicas=1 -n openshift-machine-api
```
