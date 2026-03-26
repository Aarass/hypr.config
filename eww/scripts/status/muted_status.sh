~/.config/shared/scripts/statuses.sh | while read -r line; do
  muted=$(echo "$line" | jq '.muted')
  printf '%s\n' "$muted"
done
