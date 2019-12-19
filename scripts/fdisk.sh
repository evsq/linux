#!/bin/bash

# Create new partition
fdisk /dev/sda <<EOF
n
p
3



w
EOF
# Reload kernel table
partprobe
# Create new physical volume
pvcreate /dev/sda3
# Add physical volume to a volume group
vgextend centos /dev/sda3
# Extend the size of a logical volume
lvextend -l +100%FREE /dev/centos/root
# Scan all disks for volume groups and rebuild caches
vgscan
# Activate all known volume groups in the system
vgchange -ay
# Increase the size xfs
xfs_growfs /dev/centos/root
