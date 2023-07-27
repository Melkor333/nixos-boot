#!/usr/bin/env bash

set -eo pipefail

# CD to scriptdir
cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")"

# Remove temporary data
rm -f testvm.qcow2
rm -f testvm-efi-vars.fd
#
# Start VM
nixos-rebuild build-vm-with-bootloader --flake "./#test-plymouth"
./result/bin/run-testvm-vm
