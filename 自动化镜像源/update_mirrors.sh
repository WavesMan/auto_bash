#!/bin/bash

# 定义文件路径
VERSION_FILE="ubuntu_version.txt"
SOURCES_LIST="/etc/apt/sources.list"
VERSION_FILE_URL="https://raw.githubusercontent.com/WavesMan/auto_bash/main/自动化镜像源/ubuntu_version.txt"

# 检查文件是否存在，如果不存在则下载
if [ ! -f "$VERSION_FILE" ]; then
    echo "版本文件 $VERSION_FILE 不存在，正在从 GitHub 下载..."
    curl -o "$VERSION_FILE" "$VERSION_FILE_URL"

    # 检查下载是否成功
    if [ $? -eq 0 ]; then
        echo "版本文件下载成功，保存到 $VERSION_FILE。"
    else
        echo "版本文件下载失败，请检查网络连接或URL是否正确。"
        exit 1
    fi
fi

# 读取文件内容到数组
mapfile -t VERSIONS < "$VERSION_FILE"

# 显示版本列表并让用户选择
echo "可用版本:"
for i in "${!VERSIONS[@]}"; do
    echo "$(($i+1))) ${VERSIONS[$i]}"
done

read -p "请选择版本号（输入对应的数字）: " choice

# 检查用户输入是否有效
if [ "$choice" -eq "$choice" ] 2>/dev/null && [ "$choice" -ge 1 ] && [ "$choice" -le "${#VERSIONS[@]}" ]; then
    SELECTED_VERSION=${VERSIONS[$((choice-1))]}
else
    echo "无效的选择。"
    exit 1
fi

# 构建下载链接
MIRRORS_URL="https://raw.githubusercontent.com/WavesMan/auto_bash/main/自动化镜像源/mirrors/${SELECTED_VERSION}.txt"

# 下载镜像源文件
echo "正在下载镜像源文件: $MIRRORS_URL"
curl -o "$SELECTED_VERSION" "$MIRRORS_URL"

# 检查下载是否成功
if [[ ! -f "$SELECTED_VERSION" ]]; then
    echo "错误: 镜像源文件下载失败，请检查版本或网络连接."
    exit 1
fi

# 备份当前的sources.list文件
cp "$SOURCES_LIST" "${SOURCES_LIST}.bak"

# 将下载的镜像源文件内容写入sources.list
echo "将镜像源内容写入 $SOURCES_LIST..."
cat "$SELECTED_VERSION" > "$SOURCES_LIST"

# 执行apt update和apt upgrade
echo "更新镜像源并升级系统..."
apt update && apt upgrade -y

# 清理下载的镜像源文件
rm "$SELECTED_VERSION"

echo "镜像源更新和系统升级完成."