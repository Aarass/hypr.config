#!/usr/bin/env bash

bt_status=$(echo -e "show\nquit" | bluetoothctl | grep "Powered:" | awk '{print $2}')

if [ "$bt_status" = "yes" ]; then
  connected_devices=$(echo -e "info\nquit" | bluetoothctl | grep "Connected: yes")
  if [ -n "$connected_devices" ]; then
    echo 2
  else
    echo 1
  fi
else
  echo 0
fi
