fifo=$(mktemp -u)
mkfifo "$fifo" >/dev/null 2>&1

start() {
  local pids=()
  for func_name in "$@"; do
    if declare -f "$func_name" >/dev/null; then
      $func_name &
      pids+=($!)
    else
      echo "Function '$func_name' don't exist!"
    fi
  done

  trap 'kill ${pids[@]}' EXIT
}

listen_network() {
  if [ "$(nmcli -t -f CONNECTIVITY general status)" != "none" ]; then
    printf '%s\n' "online" >"$fifo"
  else
    printf '%s\n' "offline" >"$fifo"
  fi

  nmcli monitor | while read -r line; do
    if [[ "$line" == *"disconnected"* ]]; then
      printf '%s\n' "offline" >"$fifo"
    elif [[ "$line" == *"connected"* ]]; then
      printf '%s\n' "online" >"$fifo"
    fi
  done
}

listen_mute() {
  if wpctl get-volume @DEFAULT_SINK@ | grep -q MUTED; then
    printf '%s\n' "muted" >"$fifo"
  else
    printf '%s\n' "unmuted" >"$fifo"
  fi

  pactl subscribe | while read -r line; do
    if ! echo "$line" | grep -q "change"; then
      continue
    fi

    if wpctl get-volume @DEFAULT_SINK@ | grep -q MUTED; then
      printf '%s\n' "muted" >"$fifo"
    else
      printf '%s\n' "unmuted" >"$fifo"
    fi
  done
}

listen_volume() {
  value=$(wpctl get-volume @DEFAULT_SINK@ | awk '{printf "%d\n", $2*100}')
  printf 'volume %d\n' "$value" >"$fifo"

  pactl subscribe | while read -r line; do
    if ! echo "$line" | grep -q "change"; then
      continue
    fi

    value=$(wpctl get-volume @DEFAULT_SINK@ | awk '{printf "%d\n", $2*100}')
    printf 'volume %d\n' "$value" >"$fifo"
  done
}

start listen_network listen_mute listen_volume

muted=""
online=""
volume=""

while true; do
  read -r event <"$fifo"

  case "$event" in
  online) online=1 ;;
  offline) online=0 ;;
  muted) muted=1 ;;
  unmuted) muted=0 ;;
  volume\ *) volume=${event#volume } ;;
  esac

  [ -z "$muted" ] && continue
  [ -z "$online" ] && continue
  [ -z "$volume" ] && continue

  jq -nc \
    --argjson muted "$([[ $muted -eq 1 ]] && echo true || echo false)" \
    --argjson online "$([[ $online -eq 1 ]] && echo true || echo false)" \
    --argjson volume "$volume" \
    '{
      muted: $muted,
      online: $online,
      volume: $volume,
    }'
done
