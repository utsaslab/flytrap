#!/bin/bash

cores=$1

if [ ! -f stretch.img ]; then 
    echo "stretch.img does not exist. Please run flytrap/tools/create-image.sh and move stretch.img to the flytrap root directory."
fi

if [ -z $cores ]; then
    echo "Usage: boot-vm.sh <cores>"
    exit 1
fi

sudo qemu-system-x86_64 -boot c -m 8192 -hda stretch.img -enable-kvm \
-nographic -kernel vmshare/linux-5.1/arch/x86/boot/bzImage -append \
"root=/dev/sda console=ttyS0 earlyprintk=serial memmap=128M!4G memmap=128M!4224M" \
-fsdev local,security_model=passthrough,id=fsdev0,path=vmshare -device virtio-9p-pci,\
id=fs0,fsdev=fsdev0,mount_tag=hostshare -smp $cores -net nic -net user,\
hostfwd=tcp::2222-:22 -cpu host