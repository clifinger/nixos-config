#!/usr/bin/env bash
# Fallback script to ensure laptop screen is enabled when no external monitors

# Wait a bit for the display to settle
sleep 1

# Force enable laptop screen with correct settings
wlr-randr --output eDP-1 --on --mode 2560x1600@60.000999Hz --scale 1.3 --pos 0,0
