In this module, we'll get familiar with the cluster and the install of the Windows Node. If you haven't done already, login to the bastion node provided by the RHPDS email.

```shell
ssh chernand-redhat.com@bastion.lax-e35b.sandbox886.opentlc.com
```

Next, we'll clone a repository from GitHub and utilize certain YAML files from it:

```shell
git clone --single-branch --branch dev https://github.com/RedHatWorkshops/windows-containers-quickstart.git
```

If you examine these two commands, you will observe that this demonstration already includes a Windows node and a Windows secret configuration. To provide you with the opportunity to set up these components manually, we will execute the following script to remove them.

```shell
oc get nodes -l kubernetes.io/os=windows
oc get secret -n openshift-windows-machine-config-operator cloud-private-key
```

* This script will setup your workshop by removing the Windows node from your OpenShift cluster, removing the windows secret, installing Helm, a tool for managing Kubernetes applications. It will also clone a workshop repo that we will be using throughout this demo. It will use oc and curl commands to perform these tasks.

```shell
chmod 700 ~/windows-containers-quickstart/support/setup-windows-demo.sh 
~/windows-containers-quickstart/support/setup-windows-demo.sh
```

* Before proceeding, make sure you’re admin, you will find your login details on your workshop deployment:

```shell
oc login -u admin -p {{ ADMIN_PASSWORD }}
```

* The first requisite is that you must be running OpenShift version 4.6 or newer. This cluster should have been installed at a supported version.

```shell
oc version
```

* The next requisite is that the cluster must be installed with OVNKubernetes as the SDN for OpenShift. This can only be done at install time in the install-config.yaml file. This file is stored on the cluster after install. Take a look at the setting.

```shell
oc extract cm/cluster-config-v1 -n kube-system --to=- | awk '/networkType:/{print $2}'
```

This should output OVNKubernetes as the network type.

* The next requisite is the cluster must be set up with overlay hybrid networking. This is another step that can only be done at install time. You can verify that the configuration has been done by running the following:

```shell
oc get network.operator cluster -o yaml | awk '/ovnKubernetesConfig:/{p=1} p&&/^    hybridClusterNetwork:/{print; p=0} p'
```

* The output should look like this. As you can see, the hybridOverlayConfig was set up. This is the overlay network setup on the Windows Node.

```shell
    ovnKubernetesConfig:
      egressIPConfig: {}
      gatewayConfig:
        routingViaHost: false
      genevePort: 6081
      hybridOverlayConfig:
        hybridClusterNetwork:
        - cidr: 10.132.0.0/14
          hostPrefix: 23
      mtu: 8901
      policyAuditConfig:
        destination: "null"
        maxFileSize: 50
        rateLimit: 20
        syslogFacility: local0
    type: OVNKubernetes
```

To summarize, in order to use Windows Containers on OpenShift. You will need the following:

- OpenShift version 4.6 or newer.

- OVNKubernetes as the SDN.

- Additionally set up hybrid overlay networking.

Note, that all of this is done at install time. There’s, currently, no way to configure a cluster for Windows Containers post install.



<br/><br/><br/>
<br/><br/><br/>
<br/><br/><br/>


