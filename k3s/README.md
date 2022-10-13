- **nfs** for k3s

```bash
sudo cp nfs.yaml /var/lib/rancher/k3s/server/manifests
```

export nfs in `/etc/exports` (no symlink)
```
/home/public    192.168.1.198(rw,sync,no_root_squash,no_subtree_check)
```

- **nvidia-container-runtime** for k3s

```bash
k apply -f nvidia.yaml
```
