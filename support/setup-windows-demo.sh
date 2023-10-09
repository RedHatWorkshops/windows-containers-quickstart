# Get the name of the node with the label kubernetes.io/os=windows
nohup node_name=$(oc get nodes -l kubernetes.io/os=windows -o name | cut -d/ -f2) &>/dev/null &
# Wait for the command to finish and print a message or an error 
wait $! && echo "Step 1: Getting node name complete" || echo "Step 1: Getting node name failed"

# Delete the node using the name
nohup oc delete node $node_name &>/dev/null &
# Wait for the command to finish and print a message or an error 
wait $! && echo "Step 2: Deleting node complete" || echo "Step 2: Deleting node failed"

# Download and install Helm
nohup curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 &>/dev/null &
# Wait for the command to finish and print a message or an error 
wait $! && echo "Step 3: Downloading Helm complete" || echo "Step 3: Downloading Helm failed"

nohup chmod 700 get_helm.sh &>/dev/null &
# Wait for the command to finish and print a message or an error 
wait $! && echo "Step 4: Making script executable complete" || echo "Step 4: Making script executable failed"

nohup ./get_helm.sh &>/dev/null &
# Wait for the command to finish and print a message or an error 
wait $! && echo "Step 5: Installing Helm complete" || echo "Step 5: Installing Helm failed"

# Delete the secret file named cloud-private-key in the namespace openshift-windows-machine-config-operator
nohup oc delete secret cloud-private-key -n openshift-windows-machine-config-operator &>/dev/null &
# Wait for the command to finish and print a message or an error 
wait $! && echo "Step 6: Deleting secret file complete" || echo "Step 6: Deleting secret file failed"

# Clone the windows-containers-quickstart repository from GitHub using the dev branch and only the latest commit 
nohup git clone --single-branch --branch dev https://github.com/RedHatWorkshops/windows-containers-quickstart.git &>/dev/null &
# Wait for the command to finish and print a message or an error 
wait $! && echo "Step7: Cloning repository complete" || echo "Step7: Cloning repository failed"

# Print "Done" to the screen 
echo "Done"

