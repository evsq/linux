# Linux
# Install targetcli (iSCSI)
yum install targetcli

systemctl enable target
systemctl start target

# Enter in targetcli
target

# create block storage
/backstores/block create storage01 /dev/sdb

#or LVM
/backstores/block create storage02 /dev/vg01/lv01 

# create iscsi target
/iscsi create

# move iscsi > iqn > tpg1
/iscsi/iqn.20...66d07483/tpg1

# create initiator. in my case vsphere host
acls/ create iqn.1998-01.com.vmware:esx11d3-50b4f370

# create luns on block storage
luns/ create /backstores/block/dev 

# vSphere

Choose "Host" > Configure > Storage Adapters > Add Software Adapter > Add software iSCSI adapter
If iSCSI Adapter not appear click Rescan Adapter and Rescan Storage
After add new iSCSI Software Adapter below choose Dynamic Discovery and type IP address and port iSCSI server
