# Deploying NetCandy Store Overview

In this section we will deploy the NetCandy Store application using `helm`. You can deliver your Windows workloads in the same way you deliver your Linux workloads. Since everything is just YAML, the workflow is the same. Whether that be via Helm, an Operator, or via Ansible.

## Verify That Helm Is Installed

First, make sure you're logged into the bastion host as the `ec2-user`. If you're not the `ec2-user`, become the `ec2-user` before proceeding.

```shell
sudo su - ec2-user
```

Verify that helm is installed. The deployment put the binary under `~/bin`

```shell
ls -1 ~/bin/helm
```

Make sure that the `helm` is in your `$PATH`.

```shell
export PATH=/home/ec2-user/bin:$PATH
```

At this point, verify that `helm` is working.

```shell
helm version
```

> __NOTE__: You might get this warning `WARNING: Kubernetes configuration file is group-readable`

If you get this warning, you can supress this warning with the following command

```shell
chmod go-r /home/ec2-user/.kube/config
```

Once you've verified that `helm` is working for you, you can continue to the next step.


## Deploying NetCandy Store

In order to deploy the Helm Chart, you will need some information from the cluster. Verify that you're the `system:admin` user on the cluster.

```shell
oc whoami
```

> __NOTE__ Any admin user is okay to use.

Once you've verified you are a cluster admin, you can extract the following information. You will need the hostname of the Windows node installed and the ssh-key used to login to the Windows Node. The reason for this is part of the Helm Chart deploys a Job that downloads the image of the frontend application as a `pre-deploy` task.

```shell
export WSSHKEY=$(kubectl get secret cloud-private-key -n openshift-windows-machine-config-operator -o jsonpath='{.data.private-key\.pem}')
export WNODE=$(kubectl get nodes -l kubernetes.io/os=windows -o jsonpath='{.items[0].metadata.name}')
```

The Helm Chart needed to deploy the NetCandy store is stored in  `~/windows_node_artifacts/netcandystore-1.0.1.tgz`

```shell
ls ~/windows_node_artifacts/netcandystore-1.0.1.tgz
```

> __NOTE__ If it's not in the location stated. It can be downloaded from [http://people.redhat.com/chernand/netcandystore-1.0.1.tgz](http://people.redhat.com/chernand/netcandystore-1.0.1.tgz)

With the two variables exported, you can install the application stack using `helm`

```shell
helm install ncs --namespace netcandystore \
--create-namespace --timeout=1200s \
~/windows_node_artifacts/netcandystore-1.0.1.tgz \
--set ssh.hostkey=${WSSHKEY} --set ssh.hostname=${WNODE}
```

This will look like it's "haning" or "stuck". It's not! What's happening is that the image is getting pulled into the Windows node. As stated before, Windows containers can be very big (a "small" container is about 5GB in size), so it might take some time.

After some time, you should see the following return.

```shell
NAME: ncs
LAST DEPLOYED: Sun Mar 28 00:16:05 2021
NAMESPACE: netcandystore
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
1. Get the application URL by running these commands:
oc get route netcandystore -n netcandystore -o jsonpath='{.spec.host}{"\n"}'

2. NOTE: The Windows container deployed only supports the following OS:

Windows Version:
=============
Windows Server 2019 Release 1809

Build Version:
=============

Major  Minor  Build  Revision
-----  -----  -----  --------
10     0      17763  0
```

This means it's deployed successfully!

> __NOTE__ This helm chart can be deployed on any cluster running Windows Server 2019 Release 1809
