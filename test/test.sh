#!/usr/bin/env bash

set -eo pipefail

# CD to scriptdir
cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")"


# Remove temporary data
rm -f testvm.qcow2
rm -f testvm-efi-vars.fd

# Start VM
nixos-rebuild build-vm-with-bootloader --flake "./#test-plymouth"
./result/bin/run-testvm-vm

# Mount to see debug logs
#sudo modprobe nbd
#sudo qemu-nbd --connect=/dev/nbd0 ./testvm.qcow2
#mkdir -p mnt
#sudo partx -l /dev/nbd0
#sudo mount /dev/nbd0p2 mnt/
#less mnt/var/log/plymouth-debug.log
#sudo umount mnt/ || true
#sudo qemu-nbd -d /dev/nbd0
