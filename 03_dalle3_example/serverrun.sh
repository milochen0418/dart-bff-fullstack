#!/bin/bash

# 检查是否安装了 watchexec
if ! command -v watchexec &> /dev/null
then
    echo "watchexec 未安装，正在尝试安装..."

    # 检查是否安装了 Homebrew
    if ! command -v brew &> /dev/null
    then
        echo "Homebrew 未安装，无法安装 watchexec。请先安装 Homebrew。"
        exit 1
    fi

    # 使用 Homebrew 安装 watchexec
    brew install watchexec

    echo "watchexec 安装完成。"
else
    echo "watchexec 已安装。"
fi

cd ./server
dart pub cache clean
dart pub get
watchexec --restart -e dart 'dart run' # With the tool watchexec, we support auto-reload by restarting to call `dart run`` whenever .dart ext file changed
cd ..
