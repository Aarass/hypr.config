#!/usr/bin/env bash

theme="$HOME/.config/hypr/rofi/theme/launcher.rasi"

rofi -show drun \
	-no-hover-select \
	-kb-cancel "Escape" \
	-theme ${theme}
