## Managing a Windows Node

Now that the Windows Node is up and running, you will be able to manage it like you would a Linux node. You will be able to scale and delete nodes using the MachineAPI.

* Currently, you have one Windows node.

```shell
oc get nodes -l kubernetes.io/os=windows
```

* In order to add another node, you will just scale the corespoinding MachineSet. Currently, you should have one

```shell
oc get machineset -l machine.openshift.io/os-id=Windows -n openshift-machine-api
```

You should have the below output. It shows that you have one Windows Machine managed by this MachineSet.

```shell
NAME                                       DESIRED   CURRENT   READY   AVAILABLE   AGE
cluster1-zzv5j-windows-worker-us-east-1a   1         1         1       1           138m
```

* To add another Windows Node, scale the Windows MachineSet to two replicas. This will create a new Windows Machine, and then the WMCO will add it as an OpenShift Node.

```shell
oc scale machineset -l machine.openshift.io/os-id=Windows -n openshift-machine-api --replicas=2
```

Note: Just like when you created the inital Windows Node, this can take upwards of 15 minutes. This can be another good time to take a small break.

* After some time, another Windows Node will have joined the cluster.

```shell
oc get nodes -l kubernetes.io/os=windows
```

Here’s an example output.

```shell
NAME                           STATUS   ROLES    AGE     VERSION
ip-10-0-139-232.ec2.internal   Ready    worker   15m     v1.20.0-1081+d0b1ad449a08b3
ip-10-0-143-146.ec2.internal   Ready    worker   3h18m   v1.20.0-1081+d0b1ad449a08b3
```

You can see how easy it is to manage a Windows Machine with the MachineAPI on OpenShift. It is managed by the same system as your Linux Nodes. You can even attach the Windows MachineSet Autoscaler as well

* Remove this node by scaling the Windows MachineSet back down to 1.

```shell
oc scale machineset -l machine.openshift.io/os-id=Windows -n openshift-machine-api --replicas=1
```

Warning: Please scale your Windows MachineSet to 1 before starting the next exercise.

* After some time, you should be back at 1 Windows node.

```shell
oc get nodes -l kubernetes.io/os=windows
```

If, after 15 minutes, you still have 2 nodes, please remove the oldest node.
```shell
oc delete node <ip-10-0-218-104.us-east-2.compute.internal>
```




<br/><br/><br/>
<br/><br/><br/>
<br/><br/><br/>


