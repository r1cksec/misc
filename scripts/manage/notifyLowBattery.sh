#!/bin/bash

batteryLevel=$(cat /sys/class/power_supply/BAT0/capacity)
chargingStatus=$(cat /sys/class/power_supply/BAT0/status)

if [ ${batteryLevel} -le 35 ] && [ "${chargingStatus}" != "Charging" ]
then
    echo "########## WARNING ##########" | wall
    echo "########## Low Battery ##########" | wall
    echo "########## Please Recharge ##########" | wall 
fi

