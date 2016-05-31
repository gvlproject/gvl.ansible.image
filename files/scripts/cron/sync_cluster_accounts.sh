#!/bin/bash
#
# This cron script runs in 1 minute intervals and ensures that all users in the
# master are propagated to workers. The workers pull in the master's
# passwd, sudoers, group and shadow files. Based on Derek's script for Galaxy-QLD.

# Directory in which to store the shared data
DIR=/mnt/transient_nfs/cluster_credentials

mkdir -p $DIR

## Check whether we are a worker or the master
if grep -q "role: worker" /opt/cloudman/boot/userData.yaml
then
    # I am a worker
    rsync -t -o -p $DIR/passwd.front /etc/passwd
    rsync -t -o -p $DIR/group.front /etc/group
    rsync -t -o -p $DIR/shadow.front /etc/shadow
    rsync -t -o -p $DIR/sudoers.front /etc/sudoers
else
    # I am the master
    rsync -t -o -p /etc/passwd $DIR/passwd.front
    rsync -t -o -p /etc/group $DIR/group.front
    rsync -t -o -p /etc/shadow $DIR/shadow.front
    rsync -t -o -p /etc/sudoers $DIR/sudoers.front
fi
