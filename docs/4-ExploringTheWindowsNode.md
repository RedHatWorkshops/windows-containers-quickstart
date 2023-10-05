## Exploring The Windows Node

Now that you’ve learned how to manage a Windows Node, we will explore how this node is set up. You can access this Windows node via the same mechanism as the WMCO, via SSH.

Since this cluster was installed in the cloud, the Windows Node isn’t exposed to the public internet. So we will need to deploy an ssh bastion Pod.

1. The ssh bastion pod can be deployed using the Deployment YAML provided to you in this lab.

```shell
oc apply -n openshift-windows-machine-config-operator -f windows-containers-quickstart/support/win-node-ssh.yaml
```

2. You can wait for the rollout of this ssh bastion pod.

```shell
oc rollout status deploy/winc-ssh -n openshift-windows-machine-config-operator
```

3. Once rolled out, you should have the ssh bastion pod running.

```shell
oc get pods -n openshift-windows-machine-config-operator -l app=winc-ssh
```

4. The ssh bastion pod mounts the ssh key needed to login to the Windows Node.

```shell
cat windows-containers-quickstart/support/win-node-ssh.yaml | python3 -c 'import sys, yaml, json; json.dump(yaml.safe_load(sys.stdin), sys.stdout)' | jq '.spec.template.spec.volumes'
```

5. In order to be able to ssh into this node you will need the hostname. Get this hostname with the following command and make note of it.

```shell
oc get nodes -l kubernetes.io/os=windows
```

6. Now open a bash session into the ssh bastion pod using the oc exec command.

```shell
oc exec -it deploy/winc-ssh -n openshift-windows-machine-config-operator -- bash
```

7. Use the provided sshcmd.sh command built into the pod to login to the Windows Node. Here is an example:

```shell
bash-4.4$ sshcmd.sh ip-10-0-140-10.ec2.internal
```

This should drop you into a PowerShell session. It should look something like this.

```shell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\Administrator>
```

8. Once on the Windows Node, you can see the containerd, hybrid-overlay-node, kubelet, kube-proxy, windows_exporter and windows-instance-config-daemon processes are running.


```shell
Get-Process | ?{ $_.ProcessName -match "daemon|exporter|kube|overlay|containerd" }
```


You should see the following output.

```shell
Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName                
-------  ------    -----      -----     ------     --  -- -----------                
    211      16    36544      33644      50.73   4556   0 containerd                 
    307      19    39648      41776      18.14   2468   0 hybrid-overlay-node        
    608      33    69544      90616     794.98   6040   0 kubelet                    
    340      24    42584      45592      49.63   6920   0 kube-proxy                 
    327      18    30228      23868       0.77   4124   0 windows_exporter           
    270      18    35088      33172      16.84   5852   0 windows-instance-config-daemon   
```

These are the main components needed to run a Windows Node. Remember that this node is managed the same way as a Linux node, Via the MachineAPI; so you won’t have to do much with this Windows Node.

9. You can now exit out of the PowerShell session.

```shell
exit
```

10. You can also exit out of the bash container session as well.

```shell
exit
```


<br/><br/><br/>
<br/><br/><br/>
<br/><br/><br/>




