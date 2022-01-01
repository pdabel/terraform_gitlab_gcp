#!/bin/bash

while [ ! -f /var/lib/cloud/instance/boot-finished ]; do
  echo -e "\033[1;36mWaiting for cloud-init..."
  sleep 1
done

rc=0
while [ $rc -eq 0 ]; do
  ps -ef | grep apt-get | grep -v grep > /dev/null 2>&1
  rc=$?
done