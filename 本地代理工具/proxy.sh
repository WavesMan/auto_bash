
# 让用户选择是否使用代理
read -p "启用/关闭代理(y/n): " use_proxy
if [[ "$use_proxy" =~ ^[Yy]$ ]]; then
    echo "请输入代理链接（示例：http://your-proxy-server:port）："
    read proxy_url

    # 设置代理环境变量
    export http_proxy="$proxy_url"
    export https_proxy="$proxy_url"
    echo "已设置代理：$proxy_url"
else
    #清除代理设置
    unset http_proxy
    unset https_proxy
    echo "已清除代理环境变量：$proxy_url"
fi

# 返回一次系统代理结果
env |grep -i proxy