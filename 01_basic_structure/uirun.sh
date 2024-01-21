#!/bin/bash


# 前處理是否有  $1 參數
if [ $# -eq 0 ]; then
    echo "No arguments provided. Usage: uirun.sh --list OR uirun.sh -d <device_id>"
    exit 1
fi

# 如果$1為 -d 前俿理 $2參數
if [ "$1" = "-d" ]; then
    if [ $# -eq 1 ]; then
        echo "No device id provided. Usage: uirun.sh -d <device_id>"
        cd - 
        exit 1
    fi
fi


cd ./ui

if [ "$1" = "--list" ]; then
    flutter devices
elif [ "$1" = "-d" ]; then
    device_id=$2
    if flutter devices | grep -q "$device_id"; then
        flutter clean # you need to clean before pub get
        flutter pub get
        ./create_platforms.sh
        flutter run -d "$device_id" 
    else
        echo "Device $device_id not found."
        flutter devices
    fi
else
    echo "Invalid arguments. Usage: uirun.sh --list OR uirun.sh -d <device_id>"
    exit 1
fi




cd ..
