#!/usr/bin/env bash

handle() {
  case $1 in
  activewindowv2*) /home/aaras/.config/waybar/scripts/refresh.tmux.sh ;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
