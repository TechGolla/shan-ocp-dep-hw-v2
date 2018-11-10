#!/usr/bin/env bash

export GUID=`hostname|awk -F. '{print $2}'`
export volsize="5Gi"
export nfspath="/srv/nfs/user-vols"

mkdir -p ./pv

for i in {1..25}
do
   cat << EOF > ./pv/pv$i.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv$i-volume 
spec:
  capacity:
    storage: $volsize
  accessModes:
  - ReadWriteOnce 
  nfs: 
    path: $nfspath/pv$i
    server: support1.$GUID.internal
  persistentVolumeReclaimPolicy: Recycle 
EOF
done
