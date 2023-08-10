# Deploying a Sample Application

In this module we will deploy a sample application running a webservice on the Windows Node. This application will be running inside a Windows Container on the Windows Node.

## Deploy the Application

Now, back on the bastion host, you will deploy the application in a new namespace called `windows-workloads`.

First create the namespace

```shell
oc new-project windows-workloads
```

Next, deploy the sample application.

```shell
$ oc create -n windows-workloads -f \
https://gist.githubusercontent.com/suhanime/683ee7b5a2f55c11e3a26a4223170582/raw/d893db98944bf615fccfe73e6e4fb19549a362a5/WinWebServer.yaml
```

Once deployed you can explore everything that's been created

## Explore Artifacts

The application should have deployed as a pod

```shell
$ oc get pods -n windows-workloads
NAME                             READY   STATUS    RESTARTS   AGE
win-webserver-549cd7495d-f6j95   1/1     Running   0          5m58s
```

This pod was created by a deployment. Remember to note that it has a toleration so it can run on the Windows Node.

```shell
$ oc get deploy win-webserver -n windows-workloads -o jsonpath='{.spec.template.spec.tolerations}' | jq -r
```

If you take a look at the pod, you see that it's running on the Windows Node.

```shell
$ oc get pods -n windows-workloads -o wide
NAME                             READY   STATUS    RESTARTS   AGE    IP           NODE                         NOMINATED NODE   READINESS GATES
win-webserver-549cd7495d-k7zqt   1/1     Running   0          100s   10.132.1.2   ip-10-0-138-9.ec2.internal   <none>           <none>

$ oc get nodes -l kubernetes.io/os=windows
NAME                         STATUS   ROLES    AGE   VERSION
ip-10-0-138-9.ec2.internal   Ready    worker   22m   v1.21.1-1398+98073871f173ba
```

Login to the Windows Node by first logging into the container


```shell
$ oc -n openshift-windows-machine-config-operator rsh deploy/winc-ssh
```

Then using the provided shellscript to login to the Windows Node via nodename

```shell
sh-4.4$ sshcmd.sh ip-10-0-138-9.ec2.internal
```

Now log into the Windows Node using the hostname. Example:

```shell
bash-4.4$ sshcmd.sh ip-10-0-140-10.ec2.internal
```

To view Windows containers running on the node, you need to install the `crictl` tool
to interact with the containerd runtime.

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

Here you'll see the Container running. Here is an example output.

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

Exit out of the Windows Node.

```shell
PS C:\Users\Administrator> exit
```

Also exit from the rsh session.

```shell
sh-4.4$ exit
exit
[ec2-user@bastion ~]$
```
You can create a route just like any other workload.

```shell
$ oc expose svc/win-webserver -n windows-workloads
```

You can now access it via the route.

```shell
$ curl -s http://$(oc get route win-webserver -n windows-workloads -o jsonpath='{.spec.host}')
<html><body><H1>Windows Container Web Server</H1></body></html>
```

You can `rsh` into this pod just like a Linux pod by using `oc exec`. The following command will get you a PowerShell prompt in the Windows Webserver pod.

```shell
$ oc -n windows-workloads exec -it deploy/win-webserver -- powershell
```

Once inside, you can see the process that's running the webserver.

```shell
PS C:\> tasklist /M /FI "IMAGENAME eq powershell.exe"  | Select-String -Pattern http
```

Exit out of the `exec` session before continuing.

```shell
PS C:\> exit
```
