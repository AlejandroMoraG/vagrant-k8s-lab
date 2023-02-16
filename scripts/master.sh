#!/bin/bash

## Download required images for kubernetes
sudo kubeadm config images pull

## Initialize the kubernetes cluster
sudo kubeadm init --pod-network-cidr=10.0.0.0/16 --apiserver-advertise-address=10.0.0.10 --cri-socket=unix:///run/containerd/containerd.sock

## Configure credentials
mkdir -p /home/vagrant/.kube
mkdir /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

## Create the Flannel pod network plugin
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

## Generate script for join worker nodes
kubeadm token create --print-join-command >> /etc/kubeadm_join_cmd.sh
chmod +x /etc/kubeadm_join_cmd.sh

# required for setting up password less ssh between guest VMs
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo systemctl restart sshd.service