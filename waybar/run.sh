#!/bin/bash


CONFIG_FILES="$HOME/.config/waybar/config.jsonc $HOME/.config/waybar/style.css"

trap "killall waybar" EXIT

while true; do
    # env GTK_DEBUG=interactive waybar &
    waybar &
    inotifywait -e create,modify $CONFIG_FILES
    killall waybar
done
