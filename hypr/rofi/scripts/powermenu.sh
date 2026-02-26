#!/usr/bin/env bash

theme="$HOME/.config/hypr/rofi/theme/powermenu.rasi"

uptime="`uptime -p | sed -e 's/up //g'`"

shutdown=''
reboot=''
lock=''
suspend=''
logout=''
hibernate=''

confirm_exit() {
	$("$HOME/.config/hypr/rofi/scripts/confirm.sh")
}

run_rofi() {
	echo -e "$lock\n$logout\n$suspend\n$hibernate\n$reboot\n$shutdown" | rofi \
		-dmenu \
		-p "Uptime: $uptime" \
		-mesg "Uptime: $uptime" \
		-theme ${theme}
}

case "$(run_rofi)" in
    $shutdown)
		if confirm_exit; then
			systemctl poweroff
		fi
	    ;;
    $reboot)
		if confirm_exit; then
			systemctl reboot
		fi
        ;;
    $lock)
		pidof hyprlock || hyprlock
        ;;
    $suspend)
		if confirm_exit; then
			wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 &
			playerctl pause --all-players &
			pidof hyprlock || hyprlock &
			systemctl suspend
		fi
        ;;
    $hibernate)
		if confirm_exit; then
			pidof hyprlock || hyprlock &
			systemctl hibernate
		fi
        ;;
    $logout)
		if confirm_exit; then
			hyprctl dispatch exit
		fi
        ;;
esac
