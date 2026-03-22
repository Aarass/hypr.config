wpctl get-volume @DEFAULT_SINK@ | awk '{printf "%d\n", $2*100}'
