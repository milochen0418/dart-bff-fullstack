#!/bin/bash
# Create platforms for flutter project
flutter create --platforms=windows,macos,linux,ios,android . # create platforms 

./create_platforms_utils_scripts/macos_enable_security_network_client.sh