#!/usr/bin/env bash

# trenutni workspace
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

# poslednji fokusirani window u special workspace-u
WIN_ADDR=$(hyprctl clients -j | jq -r '
  map(select(.workspace.name | startswith("special")))
  | sort_by(.focusHistoryID)
  | first
  | .address
')

# ako nema nijednog windowa u special workspace-u → exit
[ "$WIN_ADDR" = "null" ] && exit 0

# prebaci window u trenutni workspace (bez fokusa na special)
hyprctl dispatch movetoworkspace "$CURRENT_WS,address:$WIN_ADDR"
