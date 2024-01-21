#!/bin/bash

cd ./server
dart pub cache clean
dart pub get
dart run
cd ..
