~/.config/shared/scripts/statuses.sh | while read -r line; do
  volume=$(echo "$line" | jq '.volume')
  printf '%s\n' "$volume"
done
