no=
yes=

result=$(printf "$no\n$yes" | rofi -dmenu -p 'Confirmation' -mesg 'Are you Sure?' -no-click-to-exit -theme ~/.config/hypr/rofi/theme/confirm.rasi)

case "$result" in
	"$yes") exit 0 ;;
	"$no") exit 1 ;;
	*) exit 2 ;;
esac
