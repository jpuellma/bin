#!/usr/bin/bash

verbose=false
unmount=false
while getopts :uv opt ; do
  case $opt in
    v)
      verbose=true
      ;;
    u)
      unmount=true;
      ;;
    *)
      true
      ;;
  esac
done

# for i in /o790/* /mnt/J ; do
for i in /o790/* ; do
  if $unmount ; then
    $verbose && echo Unmounting $i.
    sudo umount -l $i
  elif grep -q $i /proc/mounts ; then
    $verbose && echo $i is already mounted. Remounting.
    sudo mount -o remount $i
  else
    $verbose && echo $i is not mounted. Mounting.
    sudo mount $i
  fi
done
