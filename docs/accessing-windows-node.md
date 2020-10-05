# Accessing Windows Node

The Windows Node is installed with Windows Server 2019 Datacenter. This installaton does NOT include the familiar Windows UI. Also, since we are on AWS, RDP isn't enabled anyway. So how do you access the Windows Node?

The same way as you do Linux nodes: SSH

## Installing SSH Jumphost

Like the RHCOS nodes, the Windows Node isn't accessible via the internet. Therefore you need to setup a "jumphost" for you to be able to ssh into the node.

You can run this jumphost in a container. It's included in this bastion host.

```shell
$ ls ~/windows_node_scripts/deploy-sshproxy.sh 
/home/ec2-user/windows_node_scripts/deploy-sshproxy.sh
```

Go ahead and run this script.

```shell
$ bash ~/windows_node_scripts/deploy-sshproxy.sh 
```

Once this is done you should have a jumphost running

```shell
$ oc get all -n openshift-ssh-bastion 
NAME                               READY   STATUS    RESTARTS   AGE
pod/ssh-bastion-5fcf8d7d9b-xrbl6   1/1     Running   0          46h

NAME                  TYPE           CLUSTER-IP      EXTERNAL-IP                                                              PORT(S)        AGE
service/ssh-bastion   LoadBalancer   172.30.218.57   a5a48f17b5345410b83fbee8fcf6b006-407575922.us-east-2.elb.amazonaws.com   22:31825/TCP   46h

NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ssh-bastion   1/1     1            1           46h

NAME                                     DESIRED   CURRENT   READY   AGE
replicaset.apps/ssh-bastion-5fcf8d7d9b   1         1         1       46h
```

## Logging into your node

Now you can SSH into the node via a proxy command in ssh. Go ahead and take a look at the script I provided for this.

```shell
$ cat ~/windows_node_scripts/sshcmd.sh
```

You'll notice the `ProxyCommand` that will SSH into the windows node and drop you into a `PowerShell` session.

Before you can ssh into the windows node, export your `ssh-key` by first creating an ssh shell session

```shell
$ eval `ssh-agent`
```

Then adding the `ec2-user`'s ssh-key

```shell
$ ssh-add  ${HOME}/.ssh/id_rsa
```

Grab the hostname of your windows node.

```shell
$ oc get nodes -l kubernetes.io/os=windows
NAME                                        STATUS   ROLES    AGE   VERSION
ip-10-0-147-19.us-east-2.compute.internal   Ready    worker   46h   v1.19.0-rc.2.1023+f5121a6a6a02dd
```

And use the script to login

```shell
$ bash ~/windows_node_scripts/sshcmd.sh ip-10-0-147-19.us-east-2.compute.internal
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

These are the main components needed to run a Windows Node. Remember that this node is managed the same way as RHCOS. Via the platform; so you won't have to do much with this Windows Node.

Go ahead and exit the powershell session.

```shell
PS C:\Users\Administrator> exit
```
