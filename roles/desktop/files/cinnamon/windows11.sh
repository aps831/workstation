#! /bin/bash
virsh --connect qemu:///system start windows11
virt-manager --connect qemu:///system --show-domain-console windows11
