# Deploying a Sample Application

In this module we prepare to deploy a sample application. This application will be running inside a Windows Container on the Windows Node.

## Predeployment Steps

The base image of the sample application, unfortunetly, is a big 5GB container. So if you deploy the application it'll timeout. To get around this you can prepull the image. 

First get your windows node.

```shell
$ oc get nodes -l kubernetes.io/os=windows
NAME                                        STATUS   ROLES    AGE    VERSION
ip-10-0-147-19.us-east-2.compute.internal   Ready    worker   2d1h   v1.19.0-rc.2.1023+f5121a6a6a02dd
```

Next, use my ssh script to login to the node

```shell
$ bash ~/windows_node_scripts/sshcmd.sh ip-10-0-147-19.us-east-2.compute.internal
```

This will drop you into a `powershell` prompt.

```shell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\Administrator>
```

Go ahead and pull `mcr.microsoft.com/windows/servercore:ltsc2019` 

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

You can now deploy the sample application
