#!/bin/bash

# 确定Linux发行版
if [ -f /etc/os-release ]; then
    . /etc/os-release
    server_version="${ID}"
    echo "服务器系统为${ID}"
elif [ -f /etc/redhat-release ]; then
    distro=$(cat /etc/redhat-release | awk '{print $1}')
    server_version="${distro}"
    echo "服务器系统为${distro}"
elif [ -f /etc/debian_version ]; then
    distro="Debian"
    server_version="${distro}"
    echo "服务器系统为${distro}"
else
    echo "无法确定Linux发行版版本。"
    exit 1
fi

echo "当前服务器版本为${server_version}"

# 转换为小写
server_version=$(echo "${server_version}" | tr '[:upper:]' '[:lower:]')

# 清理server_version，确保适合用于文件名
server_version=$(echo "${server_version}" | sed 's/[^a-zA-Z0-9.-]//g')

# 构造下载URL
download_url="https://raw.githubusercontent.com/WavesMan/auto_bash/main/生电服务端自动下载/downloads/${server_version}.sh"

# 下载对应的脚本
echo "下载 ${server_version}.sh 脚本..."
curl -LO "${download_url}"

# 检查下载是否成功
if [ -f "${server_version}.sh" ]; then
    echo "下载成功。"
    # 设置下载的脚本为可执行
    chmod +x "${server_version}.sh"
    # 执行下载的脚本
    bash ./"${server_version}.sh"
else
    echo "下载失败。请检查URL或您的网络连接。"
    exit 1
fi
