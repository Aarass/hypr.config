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

		notify-send "Not yet implemented"
		# if [[ -x '/usr/bin/betterlockscreen' ]]; then
		# 	betterlockscreen -l
		# elif [[ -x '/usr/bin/i3lock' ]]; then
		# 	i3lock
		# fi
        ;;
    $suspend)
		if confirm_exit; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		fi
        ;;
    $hibernate)
		if confirm_exit; then
			notify-send "Not yet implemented"
		fi
        ;;
    $logout)
		if confirm_exit; then
			hyprctl dispatch exit
			# notify-send "Not yet implemented"
		fi
        ;;
esac
