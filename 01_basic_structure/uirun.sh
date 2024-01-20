#!/bin/bash
cd ./ui
flutter clean # you need to clean before pub get
flutter pub get
flutter run
cd ..
