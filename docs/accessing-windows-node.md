# Accessing The Windows Node

The Windows Node is installed with Windows Server 2019 Datacenter. This installaton does NOT include the familiar Windows UI. Also, since we are on AWS, RDP isn't enabled anyway. So how do you access the Windows Node?

The same way as you do Linux nodes: SSH

## Logging into your node

This demo/quickstart deployed an "ssh conainter" so that you can ssh into this host. Verify that it's running.

```shell
$ oc get pods -l app=winc-ssh -n openshift-windows-machine-config-operator
NAME                        READY   STATUS    RESTARTS   AGE
winc-ssh-6b7f87bf75-cdcw2   1/1     Running   0          27m
```


This host has everything needed in order to ssh into your Windows Node. First, get the hostname of your Windows Node. For example:

```shell
$ oc get nodes -l kubernetes.io/os=windows
NAME                           STATUS   ROLES    AGE     VERSION
ip-10-0-134-193.ec2.internal   Ready    worker   3h38m   v1.19.0-rc.2.1023+f5121a6a6a02dd
```

Then, you can `rsh` into this container with the following command:

```shell
oc -n openshift-windows-machine-config-operator rsh $(oc get pods -n openshift-windows-machine-config-operator -l app=winc-ssh -o name)
```

This will give you a shell prompt:

```shell
sh-4.4$
```

You can run the ssh script (built into the contianer) providing the Windows Node nodename as an argument. Example:

```shell
sh-4.4$ sshcmd.sh ip-10-0-134-193.ec2.internal
```

This should drop you into a `PowerShell` session

```shell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\Administrator>
```

## Exploring the Node

Once you are in, you can see that the docker process is running.

```shell
PS C:\Users\Administrator> docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES 
```

You can also see the kubernetes processes, and the network overlay running on the Windows Node.

```shell
PS C:\Users\Administrator> Get-Process | ?{ $_.ProcessName -match "kube|overlay|docker" } 

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
    307      19    62876      44124     124.34   2524   0 dockerd
    229      16    35112      43112     173.63   4344   0 hybrid-overlay-node
    379      25    45636      70860      40.95    984   0 kubelet
    249      22    30048      41404   1,325.14   3408   0 kube-proxy
```

These are the main components needed to run a Windows Node. Remember that this node is managed the same way as RHCOS, Via the platform; so you won't have to do much with this Windows Node.

The base Windows Server docker image has been prepulled for you. You should be able to see it by running the `docker images` command in the PowerShell promt.

```shell
PS C:\Users\Administrator> docker images
REPOSITORY                             TAG                 IMAGE ID            CREATED             SIZE   
mcr.microsoft.com/windows/servercore   ltsc2019            715aaeac112d        5 weeks ago         5.06GB
```

> Don't be alarmed if you don't see it! You can pull the image yourself. We'll go over this in a different module

Go ahead and exit the powershell session.

```shell
PS C:\Users\Administrator> exit
```

Also exit from the rsh session.

```shell
sh-4.4$ exit
exit
[ec2-user@bastion ~]$
```