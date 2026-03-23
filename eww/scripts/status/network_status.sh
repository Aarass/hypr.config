#!/usr/bin/env bash

if ping -q -c 1 -W 1 8.8.8.8 >/dev/null 2>&1; then
  echo "Online"
else
  echo "Offline"
fi
