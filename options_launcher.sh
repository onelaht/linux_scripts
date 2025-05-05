#!/bin/sh

dir="$HOME/.dwm/options/" # or wherever your scripts are

# Build a list of script names without path or .sh extension
scripts=$(find "$dir" -type f -name "*.sh" -exec basename {} .sh \;)

# Use dmenu to pick one
selected=$(printf '%s\n' "$scripts" | dmenu) || exit 1

# If selected, build full path and execute
[ -n "$selected" ] && /bin/bash "$dir/$selected.sh" &
