# Windows MachineConfig Operator

The Windows Node was deployed and is managed by the Windows MachineConfig Operator. The WMCO is a special version of the MCO (MachineConfig Operator) that knows how to set up a Windows Node to be part of the OpenShift Cluster.

## Exploring the WMCO

The WMCO runs as an operator in the `windows-machine-config-operator` namespace. 

```shell
$ oc get pods -n windows-machine-config-operator 
NAME                                               READY   STATUS    RESTARTS   AGE
windows-machine-config-operator-6b87bf88d5-qmgft   1/1     Running   1          2d
```

You can view the logs of the pod to see information about the deployment

```shell
$ oc -n windows-machine-config-operator logs windows-machine-config-operator-6b87bf88d5-qmgft
```

A lot of debugging is done by tailing this log during a scale operation or a machineset creation.

```shell
$ oc -n windows-machine-config-operator logs -f windows-machine-config-operator-6b87bf88d5-qmgft
```

*NOTE* Another good place to look during debugging is the events in the `openshift-machine-api` namespace.

```shell
$ oc get events -n openshift-machine-api 
```

## Operator Installation

The operator was installed via OLM, currently I'm building this myself until the official operator comes out.

```shell
$ oc get CatalogSource wmco -n openshift-marketplace 
NAME   DISPLAY                            TYPE   PUBLISHER   AGE
wmco   Windows Machine Config operators   grpc               2d
```

You can take a look at the operator group installed in the `windows-machine-config-operator` namespace.

```shell
$ oc get OperatorGroup -n windows-machine-config-operator 
NAME                              AGE
windows-machine-config-operator   2d
```

Taking a loot at the subscription

```shell
$ oc get Subscription -n windows-machine-config-operator 
NAME                              PACKAGE                           SOURCE   CHANNEL
windows-machine-config-operator   windows-machine-config-operator   wmco     alpha
```

This will eventually be changed into using the official Operator. This is built using [the official codebase found on GitHub](https://github.com/openshift/windows-machine-config-operator)
