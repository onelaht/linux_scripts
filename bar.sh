#!/bin/bash

battery_path="/sys/class/power_supply/BAT0"
last_minute=""
last_status=""

while true; do
  current_minute=$(date +%M)

  # Get current battery status (Charging, Discharging, Full, etc.)
  status=$(<"$battery_path/status")

  # Trigger update if minute changed OR status changed (i.e. charger plugged/unplugged)
  if [[ "$current_minute" != "$last_minute" || "$status" != "$last_status" ]]; then
    last_minute="$current_minute"
    last_status="$status"

    # uptime
    uptime=$(awk '{h=int($1/3600); m=int(($1%3600)/60); s=int($1%60); printf "%02d:%02d:%02d", h, m ,s}' /proc/uptime)

    # battery
    if [[ -r "$battery_path/charge_now" && -r "$battery_path/charge_full" ]]; then
      now=$(<"$battery_path/charge_now")
      full=$(<"$battery_path/charge_full")
    elif [[ -r "$battery_path/energy_now" && -r "$battery_path/energy_full" ]]; then
      now=$(<"$battery_path/energy_now")
      full=$(<"$battery_path/energy_full")
    else
      now=1
      full=1
    fi

    percent=$((100 * now / full))
    if [[ "$status" == "Charging" ]]; then
      battery="${percent}+"
    else
      battery="${percent}"
    fi

    # date and time
    date_str=$(date +"%Y / %m / %d")
    time_str=$(date +"%H:%M")

    # update bar
    xsetroot -name "   [ Uptime: $uptime ]   [ Battery: ${battery}% ]   [ Date: $date_str ]   [ Time: $time_str ]   "
  fi

  sleep 1
done
