~/.config/shared/scripts/statuses.sh | while read -r line; do
  muted=$(echo "$line" | jq '.muted')
  online=$(echo "$line" | jq '.online')

  segments=()
  if [ "$online" = false ]; then
    segments+=("<span color='#ea7b7b'></span>")
  fi

  if [ "$muted" = true ]; then
    segments+=("<span color='#ea7b7b'></span>")
  fi

  joined="${segments[*]}"
  printf '%s\n' "$joined"
done
