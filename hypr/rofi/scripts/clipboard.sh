theme="$HOME/.config/hypr/rofi/theme/clipboard.rasi"
cliphist list | rofi -dmenu -i -theme ${theme} | cliphist decode | wl-copy
