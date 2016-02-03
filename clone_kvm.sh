#!/bin/bash

BASE=$1
GUEST=$2
POOL='/var/lib/libvirt/images'
#DOMAIN='jpuellma.net'
#OPTS='-o compat=1.1,lazy_refcounts'


if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <name of base VM> <name of target VM>"
    exit 1
else
    echo "Creating guest ${GUEST}"

    #Clone the template to a new host:
    virt-clone -o ${BASE} -n ${GUEST} -f ${POOL}/${GUEST}.qcow2

    #N.B. virt-sysprep gets rid of ca certs and root's ssh keys
    #Edit the new host's hostname:
    virt-sysprep -d ${GUEST} --hostname ${GUEST}

    #Start the vm:
    virsh start ${GUEST}

fi
