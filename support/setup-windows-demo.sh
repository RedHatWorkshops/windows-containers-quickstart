#!/bin/bash

# Get the name of the windows machine set using oc command and grep command
windows_machineset=$(oc get machineset -n openshift-machine-api -o name | grep windows | cut -d/ -f2) &

# Scale down the windows machine set to 0 using oc scale command
oc scale machineset $windows_machineset --replicas=0 -n openshift-machine-api &>/dev/null &&

# Wait for the command to finish and print a message
wait $! && echo "Step 1: Windows Machineset scaled" || echo "Step 1: Scaling Windows Machineset failed"

# Download and install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 &>/dev/null &&

# Make script executable
chmod 700 get_helm.sh &>/dev/null &&

./get_helm.sh &>/dev/null &
# Wait for the command to finish and print a message or an error 
wait $! && echo "Step 2: Installing Helm complete" || echo "Step 2: Installing Helm failed"

# Delete the secret file named cloud-private-key in the namespace openshift-windows-machine-config-operator
oc delete secret cloud-private-key -n openshift-windows-machine-config-operator &>/dev/null &&
# Wait for the command to finish and print a message or an error 
wait $! && echo "Step 3: Deleting secret file complete" || echo "Step 3: Deleting secret file failed"

# Make all files in the directory executable
chmod +x /home/lab-user/windows-containers-quickstart/support/* &>/dev/null &&
# Wait for the command to finish and print a message or an error 
wait $! && echo "Step 4: Make scripts executable" || echo "Step 4: Make scripts executable failed"

# Print "Done" to the screen 
echo "Done"

