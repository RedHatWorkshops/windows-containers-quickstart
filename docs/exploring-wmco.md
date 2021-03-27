# Windows MachineConfig Operator

The Windows Node was deployed and is managed by the Windows MachineConfig Operator. The WMCO is a special version of the MCO (MachineConfig Operator) that knows how to set up a Windows Node to be part of the OpenShift Cluster.

## Exploring the WMCO

The WMCO runs as an operator in the `openshift-windows-machine-config-operator` namespace. 

```shell
$ oc get pods -n openshift-windows-machine-config-operator
NAME                                               READY   STATUS    RESTARTS   AGE
windows-machine-config-operator-6b87bf88d5-qmgft   1/1     Running   1          2d
```

You can view the logs of the pod to see information about the deployment

```shell
$ oc -n openshift-windows-machine-config-operator logs windows-machine-config-operator-6b87bf88d5-qmgft
```

A lot of debugging is done by tailing this log during a scale operation or a machineset creation.

```shell
$ oc -n openshift-windows-machine-config-operator logs -f windows-machine-config-operator-6b87bf88d5-qmgft
```

*__NOTE__* Another good place to look during debugging is the events in the `openshift-machine-api` namespace.

```shell
$ oc get events -n openshift-machine-api 
```

## Operator Installation

The operator was installed via OLM. You can see more info about how to install Windows Containers
for OpenShift by visting the [official documentation page](https://docs.openshift.com/container-platform/4.6/windows_containers/windows-containers-release-notes.html) for OpenShift.

You can take a look at the operator group installed in the `windows-machine-config-operator` namespace.

```shell
$ oc get OperatorGroup -n openshift-windows-machine-config-operator 
NAME                              AGE
windows-machine-config-operator   17m
```

Taking a look at the subscription, you can see that the official operator is installed
and subscribed to the "stable" channel.

```shell
$ oc get Subscription -n openshift-windows-machine-config-operator 
NAME                              PACKAGE                           SOURCE             CHANNEL
windows-machine-config-operator   windows-machine-config-operator   redhat-operators   stable
```

To see which version of the operator is running, check the CSV.

```shell
$ oc get csv -n openshift-windows-machine-config-operator
NAME                                     DISPLAY                           VERSION   REPLACES   PHASE
windows-machine-config-operator.v1.0.2   Windows Machine Config Operator   1.0.2                Succeeded
```
