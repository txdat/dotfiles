#!/bin/sh
sudo mkdir -p /etc/docker && sudo cp docker_daemon.json /etc/docker/daemon.json
sudo mkdir -p /etc/containerd && sudo cp containerd_config.toml /etc/containerd/config.toml
kubectl apply -f nvidia.yaml