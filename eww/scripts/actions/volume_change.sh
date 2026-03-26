~/.local/bin/eww update volume="$1"
~/.local/bin/eww update muted=0
wpctl set-volume @DEFAULT_SINK@ "$1"%
wpctl set-mute @DEFAULT_SINK@ 0
