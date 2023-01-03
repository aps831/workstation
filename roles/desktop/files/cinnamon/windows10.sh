#! /bin/bash
virsh --connect qemu:///system start Windows10
virt-manager --connect qemu:///system --show-domain-console Windows10
