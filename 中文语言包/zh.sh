#!/bin/bash

# 更新软件包
sudo apt-get update

# 安装中文语言包
sudo apt-get install language-pack-zh-hans

# 切换语言环境
echo "" >> /etc/default/locale
echo "" >> /etc/default/locale
echo "# 中文系统语言环境" >> /etc/default/locale
echo "LANG=zh_CN.UTF-8" >> /etc/default/locale
echo "LANGUAGE=zh_CN:zh" >> /etc/default/locale
echo "LC_ALL=zh_CN.UTF-8" >> /etc/default/locale

# 选择是否重启系统
read -p "是否重启系统？(y/n)" answer
if [ "$answer" == "y" ]; then
    sudo reboot
else
    echo "系统语言环境设置完成，请重启系统后生效。"
    exit 1
fi
