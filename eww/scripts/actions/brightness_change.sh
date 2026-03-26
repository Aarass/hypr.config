value=$(($1 < 10 ? 10 : $1))

~/.local/bin/eww update brightness="$value"
brightnessctl set "$value"% &
