#!/bin/sh

# install 'qemu-full' in archlinux
# https://bbs.archlinux.org/viewtopic.php?pid=2061436#p2061436
# './win10_wm.sh win10_lstc_2021.iso virtio-win-0.1.229.iso'

if [ ! -f win10_wm.img ]; then
    qemu-img create -f qcow2 win10_wm.img 50G
fi

qemu-system-x86_64 \
    -drive file=win10_wm.img,format=qcow2,if=virtio \
    -drive file="$1",media=cdrom \
    -drive file="$2",media=cdrom \
    -device qemu-xhci \
    -device usb-tablet \
    -enable-kvm \
    -machine type=q35 \
    -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_time,hv_vapic,hv_vendor_id=0xDEADBEEFFF \
    -rtc clock=host,base=localtime \
    -m 8G \
    -smp sockets=1,cores=4,threads=1 \
    # -net nic -net user,hostname=windows
