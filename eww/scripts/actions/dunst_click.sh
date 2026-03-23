dunstctl set-paused toggle
muted=$(dunstctl is-paused)
~/.local/bin/eww update dunst_muted="$muted"
