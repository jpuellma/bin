#!/usr/bin/bash

verbose=false
while getopts :v opt ; do
  case $opt in
    v)
      verbose=true
      ;;
    *)
      true
      ;;
  esac
done

for i in /o790/* ; do
  if  grep -q $i /proc/mounts ; then
    if $verbose ; then
      echo $i is already mounted. Remounting.
    fi
    sudo mount -o remount $i
  else
    if $verbose ; then
      echo $i is not mounted. Mounting.
    fi
    sudo mount $i
  fi
done

