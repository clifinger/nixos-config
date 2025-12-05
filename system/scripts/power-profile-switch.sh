#!/usr/bin/env bash

# Script to switch power profile and brightness based on AC adapter status

# Get AC adapter status
AC_STATUS=$(cat /sys/class/power_supply/AC/online)

if [ "$AC_STATUS" -eq 1 ]; then
    # AC plugged in: balanced mode, 80% brightness
    powerprofilesctl set balanced
    brightnessctl set 80%
    logger "Power: AC connected - switched to balanced profile with 80% brightness"
else
    # AC unplugged: power-saver mode, 40% brightness
    powerprofilesctl set power-saver
    brightnessctl set 40%
    logger "Power: AC disconnected - switched to power-saver profile with 40% brightness"
fi
