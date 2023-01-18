#!/bin/sh
# https://docs.fedoraproject.org/en-US/quick-docs/getting-started-with-virtualization/
# https://www.funtoo.org/Windows_10_Virtualization_with_KVM

WIN_IMG=/ssd/kvm/en-us_windows_10_iot_enterprise_ltsc_2021_x64_dvd_257ad90f.iso
VIRT_IMG=/ssd/kvm/virtio-win.iso
QEMU_IMG=/ssd/kvm/win10.img

qemu-system-x86_64 --enable-kvm -drive driver=raw,file=${QEMU_IMG},if=virtio -m 6144 \
    -net nic,model=virtio -net user -cdrom ${WIN_IMG} \
    -drive file=${VIRT_IMG},index=3,media=cdrom \
    -rtc base=localtime,clock=host -smp cores=4 \
    -usb -device usb-tablet \
    -net user,smb=$HOME
