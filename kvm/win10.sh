#!/bin/sh
# https://docs.fedoraproject.org/en-US/quick-docs/getting-started-with-virtualization/
# https://www.funtoo.org/Windows_10_Virtualization_with_KVM

KVM_DIR=${1:-$(pwd)}
WIN_IMG="${KVM_DIR}/en-us_windows_10_iot_enterprise_ltsc_2021_x64_dvd_257ad90f.iso"
VIRT_IMG="${KVM_DIR}/virtio-win.iso"
QEMU_IMG="${KVM_DIR}/win10.img"

if [ ! -f ${QEMU_IMG} ]
then
    if [ ! -f ${WIN_IMG} ] || [ ! -f ${VIRT_IMG} ]
    then
        echo missing ${WIN_IMG} or ${VIRT_IMG}, skip install
        return 1
    fi

    # create virtual img (default 50G)
    qemu-img create -f raw ${QEMU_IMG} ${2:-50}G
fi

# start virtual machine (default all cpu cores and 6GB memory)
qemu-system-x86_64 --enable-kvm -drive driver=raw,file=${QEMU_IMG},if=virtio -m ${4:-6144} \
    -net nic,model=virtio -net user -cdrom ${WIN_IMG} \
    -drive file=${VIRT_IMG},index=3,media=cdrom \
    -rtc base=localtime,clock=host -smp cores=${3:-$(nproc --all)} \
    -usb -device usb-tablet \
    -net user,smb=$HOME
