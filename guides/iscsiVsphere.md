# Vsphere
Choose Host -> Configure -> Storage Adapters
Add Software Adapter -> Add software iSCSI adapter # After added adapter you'll get Identifier name, in my case "iqn.1998-01.com.vmware:esxi2-58e70795"

# iSCSI
Install and start iSCSI
```
yum install targetcli
```
```
systemctl enable --now target
```

Enter to CLI
```
targetcli
```
Create blockstorage
```
/backstores/block create storage01 /dev/sdb
```

Create iSCSI target
```
/iscsi create iqn.2020-02.com.iscsi:t1
```

Go to target directory
```
cd /iscsi/iqn.20...iscsi:t1/tpg1
```

Create initiator. Type identifier name from Vsphere
```
acls/ create iqn.1998-01.com.vmware:esxi2-58e70795 
```
Create LUN on block Storage
```
luns/ create /backstores/block/storage01
```
# Vsphere
Choose Host -> Configure -> Storage Adapters
Choose iSCSI Software Adapter -> below choose Dynamic Discovery
Add (Target Server) # Type iSCSI ip address
Click Rescan Adapter

Create new VMFS volume
Choose Host -> Storage -> New Datastore -> VMFS -> Click new storage -> VMFS 6 -> Datastore size (ALL)
