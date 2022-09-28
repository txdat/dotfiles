- **nfs** for k3s

```bash
sudo cp nfs.yaml /var/lib/rancher/k3s/server/manifests
```

- **nvidia-container-runtime** for k3s

```bash
k apply -f nvidia.yaml
```