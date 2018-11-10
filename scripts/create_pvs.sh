#!/usr/bin/env bash

export nfspath="/srv/nfs/user-vols"

mkdir -p $nfspath/pv{1..200}

echo "Creating PV for users.."

for pvnum in {1..200} ; do
  echo "$nfspath/pv${pvnum} *(rw,root_squash)" >> /etc/exports.d/openshift-uservols.exports
done

chown -R nfsnobody.nfsnobody $nfspath
chmod -R 777 $nfspath
