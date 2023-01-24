#!/bin/sh

# Variables
TARGET=""
DIR="/sys/class/backlight/nvidia_wmi_ec_backlight"

if [[ -d $DIR ]]; then
	TARGET="/sys/class/backlight/nvidia_wmi_ec_backlight"
	MAX=$(cat ${TARGET}/max_brightness)
	CURRENT=$(cat ${TARGET}/actual_brightness)
else
	TARGET="/sys/class/backlight/nvidia_wmi_ec_backlight"
	MAX=$(cat ${TARGET}/max_brightness)
	CURRENT=$(cat ${TARGET}/actual_brightness)
fi

if [[ $CURRENT -gt 0 ]]; then
	((CURRENT=CURRENT-10))
	echo $CURRENT > $TARGET/brightness
fi
