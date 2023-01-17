#!/bin/sh
export_dir="${1}"
ip_addr="${2:-192.168.1.198}"

sudo echo "${export_dir} ${ip_addr}(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports
sudo exportfs -arv

cp nfs.yaml /tmp/nfs.yaml
sed -i "s@{{export_dir}}@${export_dir}@g" /tmp/nfs.yaml
sed -i "s@{{ip_addr}}@${ip_addr}@g" /tmp/nfs.yaml
sudo mv /tmp/nfs.yaml /var/lib/rancher/k3s/server/manifests
