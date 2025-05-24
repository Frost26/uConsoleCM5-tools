#!/bin/bash

# Device may be named BAT0, BAT1, or similar. Adjust if needed.
BATTERY_PATH="/sys/class/power_supply/axp20x-battery"

# Fallback if path doesn't exist
if [ ! -d "$BATTERY_PATH" ]; then
    echo "Battery path not found at $BATTERY_PATH"
    exit 1
fi

STATUS=$(cat "$BATTERY_PATH/status")
ENERGY_NOW=$(cat "$BATTERY_PATH/energy_now")
ENERGY_FULL=$(cat "$BATTERY_PATH/energy_full")
VOLTAGE=$(cat "$BATTERY_PATH/voltage_now")
POWER_NOW=$(cat "$BATTERY_PATH/power_now")

# Convert micro-units to more readable units
ENERGY_NOW_MWH=$((ENERGY_NOW / 1000))
ENERGY_FULL_MWH=$((ENERGY_FULL / 1000))
VOLTAGE_V=$(echo "scale=2; $VOLTAGE / 1000000" | bc)
POWER_MW=$(echo "scale=2; $POWER_NOW / 1000000" | bc)

# Calculate percentage
PERCENT=$((100 * ENERGY_NOW / ENERGY_FULL))

echo "Battery Status"
echo "----------------"
echo "Status     : $STATUS"
echo "Charge     : $PERCENT% ($ENERGY_NOW_MWH / $ENERGY_FULL_MWH mWh)"
echo "Voltage    : $VOLTAGE_V V"
echo "Power Draw : $POWER_MW W"

