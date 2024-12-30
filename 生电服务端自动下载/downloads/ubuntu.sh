#!/bin/bash

# 定义脚本所在目录
SCRIPT_DIR="$(dirname "$0")"
VERSION_FILE="$SCRIPT_DIR/version.txt"
VERSION_FILE_URL="https://raw.githubusercontent.com/WavesMan/auto_bash/main/生电服务端自动下载/version.txt"

# 检查version.txt文件是否存在，如果不存在则下载
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

# 读取版本列表
versions=()
while read -r version; do
    versions+=("$version")
done < "$VERSION_FILE"

# 检查是否有至少一个版本
if [ ${#versions[@]} -eq 0 ]; then
    echo "版本文件中没有版本信息。"
    exit 1
fi

# 显示版本列表并让用户选择
echo "可用版本:"
for i in "${!versions[@]}"; do
    echo "$(($i+1))) ${versions[$i]}"
done

read -p "请选择版本号（输入对应的数字）: " choice

# 检查用户输入是否有效
if [ "$choice" -eq "$choice" ] 2>/dev/null && [ "$choice" -ge 1 ] && [ "$choice" -le "${#versions[@]}" ]; then
    selected_version=${versions[$((choice-1))]}
else
    echo "无效的选择。"
    exit 1
fi

# 版本比较函数
version_ge() {
    # 比较两个版本号，是否大于等于
    local v1=$1 v2=$2
    [ "$(printf '%s\n' "$v1" "$v2" | sort -V | head -n1)" = "$v2" ]
}

# 判断下载哪个JDK
if version_ge "$selected_version" "1.20.5"; then
    jdk_version="21"
elif version_ge "$selected_version" "1.18"; then
    jdk_version="17"
else
    jdk_version=""
fi

    # 下载并安装JDK
    echo "正在下载并安装JDK $jdk_version..."

    # 更新包列表
    sudo apt-get update

    # 安装OpenJDK
    if [ "$jdk_version" = "17" ]; then
        sudo apt-get install -y openjdk-17-jdk
    elif [ "$jdk_version" = "21" ]; then
        # 添加Adoptium仓库
        wget "https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz"
        mkdir /opt/jdk21
        tar -xvf jdk-21_linux-x64_bin.tar.gz -C /opt/jdk21
        cat << EOF > /~/.bashrc
        export JAVA_HOME=/opt/jdk21/jdk-21
        export PATH=$PATH:/opt/jdk21/bin
        EOF
        source ~/.bashrc    

    fi

    # 设置JAVA_HOME
    if [ "$jdk_version" = "17" ]; then
        export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
    elif [ "$jdk_version" = "21" ]; then
        export JAVA_HOME=/usr/lib/jvm/temurin-$jdk_version-jdk-amd64
    fi

    # 检查安装是否成功
    if [ -d "$JAVA_HOME" ]; then
        echo "JDK $jdk_version 安装成功。"
    else
        echo "JDK $jdk_version 安装失败。"
        exit 1
    fi

    # 清除代理设置
    unset http_proxy
    unset https_proxy
else
    echo "选择的版本号不需要下载JDK。"
fi

# 生成下载链接
download_url="https://meta.fabricmc.net/v2/versions/loader/${selected_version}/0.16.9/1.0.1/server/jar"

# 下载文件
echo "正在下载 $download_url ..."
curl -OJ "$download_url"

# 检查下载是否成功
if [ $? -eq 0 ]; then
    echo "下载完成。"
else
    echo "下载失败。"
    exit 1
fi
