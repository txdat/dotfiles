#!/bin/sh
sudo cp nfs.yaml /var/lib/rancher/k3s/server/manifests
sudo echo "/hdd/.nfs 192.168.1.198(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
sudo exportfs -arv