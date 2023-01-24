#!/bin/sh

# Variables
DOT=""
D="-"
BAR=""
TARGET=""
DIR="/sys/class/backlight/nvidia_wmi_ec_backlight"
CURRENT=0

if [[ -d $DIR ]]; then
	TARGET="/sys/class/backlight/nvidia_wmi_ec_backlight"
	MAX=$(cat ${TARGET}/max_brightness)
	CURRENT=$(cat ${TARGET}/actual_brightness)
else
	TARGET="/sys/class/backlight/nvidia_wmi_ec_backlight"
	MAX=$(cat ${TARGET}/max_brightness)
	CURRENT=$(cat ${TARGET}/actual_brightness)
fi

((CURRENT=CURRENT/50))
for ((i = 0; i < $CURRENT; i++)); do
	BAR+=$DOT
done
for ((i = $CURRENT; i < 10; i++)); do
	BAR+=$D
done
echo "$BAR"
