## Running a Windows Container Workload

Before you deploy a sample Windows Container workload, let’s explore how the container gets scheduled on the Windows node.

If you run an oc describe on the Windows Node, you’ll see it has a taint.

```shell
oc describe nodes -l kubernetes.io/os=windows | grep Taint
```

You should see the following output.

```shell
Taints:             os=Windows:NoSchedule
```

Every Windows Node will come with this taint by default. This taint will "repel" all workloads that don’t tolerate this taint. It is a part of the WMCO’s job to ensure that all Windows Nodes have this taint.

In this lab, there is a sample workload saved under windows-containers-quickstart/support/winc-sample-workload.yaml. Let’s explore this file a bit before we apply it.

```shell
cat windows-containers-quickstart/support/winc-sample-workload.yaml | python3 -c 'import sys, yaml, json; json.dump(yaml.safe_load(sys.stdin), sys.stdout, indent=4)' | jq '.items[2].spec.template.spec.tolerations'
```

The output should look something like this.

```shell
- key: "os"
  value: "Windows"
  Effect: "NoSchedule"
```

This sample workload has the toleration in place to be able to run on the Windows Node. However, that’s not enough. A nodeSelector will need to be present as well.

```shell
cat windows-containers-quickstart/support/winc-sample-workload.yaml | python3 -c 'import sys, yaml, json; json.dump(yaml.safe_load(sys.stdin), sys.stdout)' | jq '.items[2].spec.template.spec.nodeSelector'
```

The output should look something like this.

```shell
kubernetes.io/os: windows
```

So here, the nodeSelector will place this container on the Windows Node. Furthermore, the appropriate toleration is in place so the Windows Node won’t repel the container.

One last thing to look at. Take a look at the container that is being deployed.

```shell
grep -A 1000 'name: win-webserver' winc-sample-workload.yaml | grep 'image:' | awk '{print $2}'
```

Apply this YAML file to deploy the sample workload.

```shell
oc apply -f windows-containers-quickstart/support/
```

Wait for the deployment to finish rolling out. This can take 5-10 minutes as Windows images are large in size.

```shell
oc rollout status deploy/win-webserver -n winc-sample
```

If you check the pod, you can see that it’s running on the Windows Node. Look at the wide output of the Pod and select the Windows Node to verify.

```shell
oc get pods -n winc-sample  -o wide
oc get nodes -l kubernetes.io/os=windows
```

Make a note of the Windows Node name, we will log into the node using the bastion ssh container.

```shell
oc exec -it deploy/winc-ssh -n openshift-windows-machine-config-operator -- bash
```

Now log into the Windows Node using the hostname. Example:

```shell
bash-4.4$ sshcmd.sh ip-10-0-140-10.ec2.internal
```

To view Windows containers running on the node, you need to install the crictl tool to interact with the containerd runtime.

```shell
$ProgressPreference = "SilentlyContinue"; wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.27.0/crictl-v1.27.0-windows-amd64.tar.gz -o crictl-v1.27.0-windows-amd64.tar.gz; tar -xvf crictl-v1.27.0-windows-amd64.tar.gz -C C:\Windows\
```

Now lets configure crictl.

```shell
crictl config --set runtime-endpoint="npipe:\\\\.\\pipe\\containerd-containerd"
```

Here, you can see the Windows container running on the node.

```shell
crictl ps
```

Here you’ll see the Container running. Here is an example output.

```shell
CONTAINER           IMAGE               CREATED             STATE               NAME                ATTEMPT             POD ID              POD
ac18c2aa692cf       66a1a48cbc112       2 minutes ago       Running             windowswebserver    0                   a2f1b580c659c       win-webserver-7b76494c5-s9m2q
```

You can also see the images downloaded on the host.

```shell
crictl images
```

You should see the following output.

```shell
IMAGE                                    TAG                 IMAGE ID            SIZE
mcr.microsoft.com/oss/kubernetes/pause   3.6                 9adbbe02501b1       104MB
mcr.microsoft.com/windows/servercore     ltsc2019            66a1a48cbc112       2.02GB
```

Go ahead an logout of the Windows Node

```shell
exit
```

You can also exit out of the bash container session as well.

```shell
exit
```

You can interact with the Windows Container workload as you would any other pod. For instance you can remote shell into the container itself by calling the Powershell command.

```shell
oc -n winc-sample exec -it $(oc get pods -l app=win-webserver -n winc-sample -o name ) -- powershell
```

This should put you in a Powershell session in the Windows Container. It should look something like this

```shell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\>
```

Here, you can query for the running HTTP process.


Note: You may have to press ENTER to execute the following commands while in the Windows Container for them to run.

```shell
Get-WmiObject Win32_Process -Filter "name = 'powershell.exe'" | Select-Object CommandLine | Select-String -Pattern http
```

Go ahead an logout of the Windows Container.

```shell
exit
```

You can interact with the Windows Container Deployment the same as you would for a Linux one. Scale the Deployment of the Windows Container:

```shell
oc scale deploy/win-webserver -n winc-sample --replicas=2
```

You should now have two Pods running.

```shell
oc get pods -n winc-sample
```
