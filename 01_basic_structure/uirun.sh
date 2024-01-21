#!/bin/bash
cd ./ui
flutter clean # you need to clean before pub get
flutter pub get
./create_platforms.sh

flutter run -d macos
cd ..
