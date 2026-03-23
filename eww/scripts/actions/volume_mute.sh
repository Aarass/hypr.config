wpctl set-mute @DEFAULT_SINK@ toggle

muted=$(wpctl get-volume @DEFAULT_SINK@ | grep -q MUTED && echo 1 || echo 0)
~/.local/bin/eww update muted="$muted"
