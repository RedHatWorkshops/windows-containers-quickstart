# Get the name of the node with the label kubernetes.io/os=windows
node_name=$(oc get nodes -l kubernetes.io/os=windows -o name | cut -d/ -f2)

# Delete the node using the name
oc delete node $node_name

# Download and install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

