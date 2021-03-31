# Deploying a Sample Application

In this module we prepare to deploy a sample application. This application will be running inside a Windows Container on the Windows Node.

## Predeployment Steps

Before we deploy the sample Windows Container application; we'll need to make sure the image is prepulled on the Windows Node (since the base image is about 5G in size).

First get your windows node.

```shell
$ oc get nodes -l kubernetes.io/os=windows
NAME                                        STATUS   ROLES    AGE    VERSION
ip-10-0-147-19.us-east-2.compute.internal   Ready    worker   2d1h   v1.19.0-rc.2.1023+f5121a6a6a02dd
```

Next, login to the ssh container

```shell
oc -n openshift-windows-machine-config-operator rsh $(oc get pods -n openshift-windows-machine-config-operator -l app=winc-ssh -o name)
```

Then use the provided script in the container

```shell
sh-4.4$ sshcmd.sh ip-10-0-147-19.us-east-2.compute.internal
```

This will drop you into a `powershell` prompt.

```shell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\Administrator>
```

Make sure the image is on the node.

```shell
PS C:\Users\Administrator> docker images
REPOSITORY                             TAG                 IMAGE ID            CREATED             SIZE   
mcr.microsoft.com/windows/servercore   ltsc2019            715aaeac112d        5 weeks ago         5.06GB 
```

If it's there, you can exit and move on to the next module.

```shell
PS C:\Users\Administrator> exit
```

You can now deploy the sample application

## Pulling The Base Image

If the image is *__NOT__* on the node, go ahead and pull `mcr.microsoft.com/windows/servercore:ltsc2019` 

```shell
PS C:\Users\Administrator> docker pull mcr.microsoft.com/windows/servercore:ltsc2019
```

This will take a while, but once pulled. It should appear on the node by running `docker images` on the node.

```shell
PS C:\Users\Administrator> docker images
REPOSITORY                             TAG                 IMAGE ID            CREATED             SIZE   
mcr.microsoft.com/windows/servercore   ltsc2019            715aaeac112d        4 weeks ago         5.06GB 
```

After the image is loaded in, exit the Windows Node.

```shell
PS C:\Users\Administrator> exit
```

Also exit from the rsh session.

```shell
sh-4.4$ exit
exit
[ec2-user@bastion ~]$
```

You can now deploy the sample application
