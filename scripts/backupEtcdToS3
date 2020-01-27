#!/bin/bash

source /etc/sysconfig/kube-apiserver
export DATESTAMP=`date +%d%m%Y_%H_%M`
export BACKUP_PATH=/tmp
export BACKUP_FILE=${BACKUP_PATH}/etcd_backup.db
export BACKUP_TAR=${BACKUP_PATH}/etcd_${DATESTAMP}.tar.gz
export ETCDCTL_CACERT=/etc/ssl/etcd/etcd-ca.crt
export ETCDCTL_CERT=/etc/ssl/etcd/etcd.crt
export ETCDCTL_KEY=/etc/ssl/etcd/etcd.key
export ETCDCTL_ENDPOINTS=$ETCD_SERVERS
export S3CMD_PATH=s3://etcd-backup

# creates a backup of the current cluster
echo "Starting cluster backup"
ETCDCTL_API=3 etcdctl snapshot save ${BACKUP_FILE}
# tar backup
cd ${BACKUP_PATH}
tar -cvzf ${BACKUP_TAR} ${BACKUP_FILE}
rm -rf ${BACKUP_FILE}
# uploading backup to s3
echo "Uploading backup to s3"
s3cmd put ${BACKUP_TAR} ${S3CMD_PATH}
