muted=$(wpctl get-volume @DEFAULT_SINK@ | grep -q MUTED && echo 0 || echo 1)
~/.local/bin/eww update muted="$muted"
wpctl set-mute @DEFAULT_SINK@ toggle &
