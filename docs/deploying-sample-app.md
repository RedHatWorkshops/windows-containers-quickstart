# Deploying a Sample Application

In this module we will deploy a sample application running a webservice on the Windows Node. This application will be running inside a Windows Container on the Windows Node.

## Deploy the Application

Now, back on the bastion host, you will deploy the application in the `default` namespace.

```shell
$ oc create -n default -f \
https://gist.githubusercontent.com/suhanime/683ee7b5a2f55c11e3a26a4223170582/raw/d893db98944bf615fccfe73e6e4fb19549a362a5/WinWebServer.yaml
```

> In order to deploy into a *__different__* namespace, SCC must be disabled in that namespace. This should *__NEVER__* be used in production, and any namespace that this has been done to *__SHOULD NOT__* be used to run Linux pods.
> To skip SCC for a namespace the label `openshift.io/run-level = 1` should be applied to the namespace. This will apply to both Linux and windows pods, and thus (again) Linux pods *__SHOULD NOT__* be deployed into this namespace.

Once deployed you can explore everything that's been created

## Explore Artifacts

The application should have deployed as a pod

```shell
$ oc get pods -n default
NAME                             READY   STATUS    RESTARTS   AGE
win-webserver-549cd7495d-f6j95   1/1     Running   0          5m58s
```

This pods was deployed by a deployment. Remember to note that it has a toleration so it can run on the Windows Node.

```shell
$ oc get deploy win-webserver -n default -o jsonpath='{.spec.template.spec.tolerations}' | jq -r
```

If you take a look at the pod, you see that it's running on the Windows Node.

```shell
$ oc get pods -n default -o wide
NAME                             READY   STATUS    RESTARTS   AGE     IP           NODE                                        NOMINATED NODE   READINESS GATES
win-webserver-549cd7495d-f6j95   1/1     Running   0          8m14s   10.132.0.2   ip-10-0-147-19.us-east-2.compute.internal   <none>           <none>

$ oc get nodes -l kubernetes.io/os=windows
NAME                                        STATUS   ROLES    AGE    VERSION
ip-10-0-147-19.us-east-2.compute.internal   Ready    worker   2d1h   v1.19.0-rc.2.1023+f5121a6a6a02dd
```

Login to the Windows Node by first logging into the container


```shell
oc -n openshift-windows-machine-config-operator rsh $(oc get pods -n openshift-windows-machine-config-operator -l app=winc-ssh -o name)
```

Then using the provided shellscript to login to the Windows Node via nodename

```shell
sh-4.4$ sshcmd.sh ip-10-0-147-19.us-east-2.compute.internal
```

Once in the Windows Node, see running docker images.

```shell
PS C:\Users\Administrator> docker ps
CONTAINER ID        IMAGE                                          COMMAND                  CREATED             STATUS              PORTS
      NAMES
8d2aec639ec3        715aaeac112d                                   "powershell.exe -com…"   11 minutes ago      Up 11 minutes
      k8s_windowswebserver_win-webserver-549cd7495d-f6j95_default_7b3066a3-9ca9-496f-bc6e-d8fb29c251c3_0
e0aa2a286e42        mcr.microsoft.com/oss/kubernetes/pause:1.3.0   "cmd /S /C pauseloop…"   11 minutes ago      Up 11 minutes
      k8s_POD_win-webserver-549cd7495d-f6j95_default_7b3066a3-9ca9-496f-bc6e-d8fb29c251c3_0
```

Exit out of the Windows Node

```shell
PS C:\Users\Administrator> exit
```

You can create a route just like any other workload.

```shell
$ oc expose svc/win-webserver
```

You can now access it via the route.

```shell
$ curl -s http://$(oc get route win-webserver -n default -o jsonpath='{.spec.host}')
<html><body><H1>Windows Container Web Server</H1></body></html>
```

You can `rsh` into this pod just like a Linux pod by using `oc exec`. The following command will get you a PowerShell prompt in the Windows Webserver pod.

```shell
$ oc exec -it $(oc get pods -l app=win-webserver -o name) powershell
```

Once inside, you can see the process that's running the webserver.

```shell
PS C:\> tasklist /M /FI "IMAGENAME eq powershell.exe"  | Select-String -Pattern http
```

Exit out of the `rsh` session before continuing.

```shell
PS C:\> exit
```
