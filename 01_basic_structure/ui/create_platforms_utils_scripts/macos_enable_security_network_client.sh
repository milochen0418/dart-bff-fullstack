#!/bin/bash

# 定義 .entitlements 文件的路徑
debug_entitlements="macos/Runner/DebugProfile.entitlements"
release_entitlements="macos/Runner/Release.entitlements"

# 函數：檢查並安裝 xmlstarlet
check_and_install_xmlstarlet() {
    if ! command -v xmlstarlet &> /dev/null; then
        echo "xmlstarlet could not be found, attempting to install..."
        if ! command -v brew &> /dev/null; then
            echo "Error: Homebrew not installed. Cannot install xmlstarlet."
            exit 1
        fi
        brew install xmlstarlet
    fi
}

# 函數：添加或更新 network.client 鍵
add_or_update_network_client_key() {
    local file=$1
    if ! xmlstarlet sel -t -c "//dict/key[.='com.apple.security.network.client']" $file &> /dev/null; then
        echo "Adding com.apple.security.network.client to $file"
        xmlstarlet ed -L -s '//dict' -t elem -n 'key' -v 'com.apple.security.network.client' $file
        xmlstarlet ed -L -s "//dict/key[.='com.apple.security.network.client']" -t elem -n 'true' -v '' $file
    else
        echo "Key com.apple.security.network.client already exists in $file"
    fi
}

# 檢查並安裝 xmlstarlet
check_and_install_xmlstarlet

# 檢查並修改 DebugProfile.entitlements
add_or_update_network_client_key $debug_entitlements

# 檢查並修改 Release.entitlements
add_or_update_network_client_key $release_entitlements
