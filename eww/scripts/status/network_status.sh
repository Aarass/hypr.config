~/.config/shared/scripts/statuses.sh | while read -r line; do
  online=$(echo "$line" | jq '.online')
  printf '%s\n' "$online"
done
