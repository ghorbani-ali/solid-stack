#!/bin/bash

KUBESPRAY_VERSION=v2.28.1
KUBESPRAYDIR=kubespray
VENVDIR=kubespray-venv
INVENTORY_DIR=cluster-inventory

KUBE_MASTER_NODE_IP=192.168.56.101
KUBECONFIG="$PWD/kubeconfig.yaml"
CILIUM_VERSION=1.18.2

# Create & start cluster
vagrant up

# setup Kubespray & dependencies
git clone git@github.com:kubernetes-sigs/kubespray.git --depth 1 --branch=$KUBESPRAY_VERSION $KUBESPRAYDIR
python3.12 -m venv $VENVDIR
source $VENVDIR/bin/activate
cd $KUBESPRAYDIR
pip3.12 install -U -r requirements.txt

# provision cluster using Kubespray
cp -r $INVENTORY_DIR kubespray/inventory
ansible-playbook -i inventory/$INVENTORY_DIR /inventory.ini -u vagrant --become-user root --ask-pass --ask-become-pass -b -v cluster.yml

# Featch admin kubeconfig
vagrant ssh k8s-master1 -c "sudo cat /etc/kubernetes/admin.conf" > kubeconfig.yaml
sed -i -e "s/127.0.0.1/$KUBE_MASTER_NODE_IP/g" kubeconfig.yaml

# Change CNI dir owner to root
vagrant ssh k8s-master1 -c "sudo chown -R root /opt/cni/bin"
vagrant ssh k8s-master2 -c "sudo chown -R root /opt/cni/bin"
vagrant ssh k8s-master3 -c "sudo chown -R root /opt/cni/bin"
vagrant ssh k8s-worker1 -c "sudo chown -R root /opt/cni/bin"
vagrant ssh k8s-worker2 -c "sudo chown -R root /opt/cni/bin"

# Install Cilium CNI
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --version $CILIUM_VERSION --namespace kube-system -f ./cilium/values-patch.yaml