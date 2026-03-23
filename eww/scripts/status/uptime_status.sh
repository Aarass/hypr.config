#!/usr/bin/env bash

uptime | awk '{print $3}' | awk '{ sub(/.$/, ""); print }'
