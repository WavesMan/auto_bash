#!/bin/bash

# 定义文件路径
MIRRORS_FILE="ubuntu_version"
SOURCES_LIST="/etc/apt/sources.list"

# 检查文件是否存在
if [[ ! -f "$MIRRORS_FILE" ]]; then
    echo "错误: 文件 $MIRRORS_FILE 不存在，准备下载版本文件"
    curl -OJ "https://raw.githubusercontent.com/auto-bash/auto_bash/main/自动化镜像源/ubuntu_version"
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

# 检查是否选择了有效的版本
if [[ -z "$VERSION" ]]; then
    echo "未选择有效的版本，脚本退出."
    exit 1
fi

# 将版本中的空格替换为"-"，用于构建下载链接
DOWNLOAD_VERSION=$(echo "Ubuntu-${VERSION}" | tr ' ' '-')

# 构建下载链接
MIRRORS_URL="https://raw.githubusercontent.com/auto-bash/auto_bash/main/自动化镜像源/mirrors/${DOWNLOAD_VERSION}"

# 下载镜像源文件
echo "正在下载镜像源文件: $MIRRORS_URL"
curl -O "$MIRRORS_URL"

# 检查下载是否成功
if [[ ! -f "$DOWNLOAD_VERSION" ]]; then
    echo "错误: 镜像源文件下载失败，请检查版本或网络连接."
    exit 1
fi

# 备份当前的sources.list文件
cp "$SOURCES_LIST" "${SOURCES_LIST}.bak"

# 将下载的镜像源文件内容写入sources.list
echo "将镜像源内容写入 $SOURCES_LIST..."
cat "$DOWNLOAD_VERSION" > "$SOURCES_LIST"

# 执行apt update和apt upgrade
echo "更新镜像源并升级系统..."
apt update && apt upgrade -y

# 清理下载的镜像源文件
rm "$DOWNLOAD_VERSION"

echo "镜像源更新和系统升级完成."