title="$(hyprctl activewindow -j 2>/dev/null | jq -r '.title // empty' || true)"
title="${title//🔔 /}"

# Očekujemo title u formatu: $SESSION_ID|@WINDOW_ID
if [[ -z "${title}" || "${title}" != *"|"* ]]; then
  jq -nc '{text:""}'
  exit 0
fi

session_id="${title%%|*}"
active_window_id="${title#*|}"

display=""

session_name="$(tmux display-message -pt "${session_id}" '#{session_name}' 2>/dev/null || true)"
if [[ -z "${session_name}" ]]; then
  jq -nc '{text:""}'
  exit 0
fi

mapfile -t windows < <(
  tmux list-windows -t "${session_id}" -F '#{window_id} #{window_index} #{window_name}' 2>/dev/null || true
)

for line in "${windows[@]}"; do
  window_id="${line%% *}"
  rest="${line#* }"
  window_index="${rest%% *}"

  if [[ "${window_id}" == "${active_window_id}" ]]; then
    display+="<span><b>${window_index}:●</b></span> "
  else
    display+="<span>${window_index}:○</span> "
  fi
done

display="${display::-1}"
display="${display% }"

jq -nc \
  --arg text "${display}" \
  '{text:$text, class:"tmux"}'
