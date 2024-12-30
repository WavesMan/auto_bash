#!/bin/bash

# 定义文件路径
MIRRORS_FILE="mirrors-tuna.txt"
SOURCES_LIST="/etc/apt/sources.list"

# 检查文件是否存在
if [[ ! -f "$MIRRORS_FILE" ]]; then
    echo "错误: 文件 $MIRRORS_FILE 不存在，准备下载版本文件"
    curl -OJ "https://raw.githubusercontent.com/auto-bash/auto_bash/main/自动化镜像源/mirrors-tuna.txt"
    exit 1
fi

# 提取可用的Ubuntu版本
VERSIONS=$(grep -oP 'Ubuntu \K[0-9]+\.[0-9]+ LTS \(\K[^)]+' "$MIRRORS_FILE" | sort -u)

# 显示可用的版本供用户选择
echo "可用的Ubuntu版本:"
select VERSION in $VERSIONS; do
    if [[ -n "$VERSION" ]]; then
        break
    else
        echo "无效的选择，请重试."
    fi
done

# 提取对应版本的镜像源内容
MIRRORS_CONTENT=$(awk -v version="$VERSION" '/Ubuntu [0-9]+\.[0-9]+ LTS \('"$VERSION"'\)/,/^$/' "$MIRRORS_FILE")

# 备份当前的sources.list文件
cp "$SOURCES_LIST" "${SOURCES_LIST}.bak"

# 将镜像源内容写入sources.list文件
echo "$MIRRORS_CONTENT" | grep -v '^#' > "$SOURCES_LIST"

# 执行apt update和apt upgrade
echo "更新镜像源并升级系统..."
apt update && apt upgrade -y

echo "镜像源更新和系统升级完成."