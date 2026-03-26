mkfifo /tmp/warning_events >/dev/null 2>&1

listen_network() {
  nmcli monitor | while read -r line; do
    if [[ "$line" == *"disconnected"* ]]; then
      printf '%s\n' "offline" >/tmp/warning_events
    elif [[ "$line" == *"connected"* ]]; then
      printf '%s\n' "online" >/tmp/warning_events
    fi
  done
}

initial_network() {
  if [ "$(nmcli -t -f CONNECTIVITY general status)" != "none" ]; then
    echo 1
  else
    echo 0
  fi
}

listen_mute() {
  pactl subscribe | while read -r line; do
    if ! echo "$line" | grep -q "change"; then
      continue
    fi

    if wpctl get-volume @DEFAULT_SINK@ | grep -q MUTED; then
      printf '%s\n' "muted" >/tmp/warning_events
    else
      printf '%s\n' "unmuted" >/tmp/warning_events
    fi
  done
}

initial_muted() {
  if wpctl get-volume @DEFAULT_SINK@ | grep -q MUTED; then
    echo 1
  else
    echo 0
  fi
}

online="$(initial_network)"
muted="$(initial_muted)"

on_change() {
  display=""
  if [ "$online" = 0 ]; then
    display+="<span color='#ea7b7b'></span>"
  fi

  if [ "$display" != "" ]; then
    display+=" "
  fi

  if [ "$muted" = 1 ]; then
    display+="<span color='#ea7b7b'></span>"
  fi

  printf '%s\n' "$display"
}

pids=()
listen_network &
pids+=($!)
listen_mute &
pids+=($!)

trap 'kill ${pids[@]}' EXIT

on_change
while true; do
  read -r event </tmp/warning_events

  case "$event" in
  online) online=1 ;;
  offline) online=0 ;;
  muted) muted=1 ;;
  unmuted) muted=0 ;;
  esac

  on_change
done
