#!/bin/bash

## Add master node to hosts file for name resolution
echo 10.0.0.10 controlplane.k8s.lab >> /etc/hosts

## Install sshpass
dnf install -y sshpass

## Recover kubeadm join script and join the worker node to the cluster
sshpass -p "vagrant" scp -o StrictHostKeyChecking=no vagrant@192.168.205.10:/etc/kubeadm_join_cmd.sh .
sh ./kubeadm_join_cmd.sh