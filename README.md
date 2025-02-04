# Windows_bat
> **适用于Windows10以上系统的自动化bat脚本**

## 暂停Windows系统更新.bat
使Windows10以上系统暂停自动更新，防止系统自动升级
<br>当前版本bat运行后将会使Windows自动更新暂停至2050-01-01 00:00:00
<br>用法：
```
下载 "暂停Windows系统更新.bat"
运行 "暂停Windows系统更新.bat"
选择 "1. 暂停Windows自动更新" 将会使Windows自动更新暂停至2050-01-01 00:00:00
选择 "2. 取消暂停Windows自动更新" Windows自动更新将恢复正常
```
> 如果您需要修改此脚本，请注意此脚本使用的字符集为ANSI，请使用记事本等文本编辑器打开并修改


---
# auto_bash
> **适用于Linux系统的自动化bash脚本**


## 自动化镜像源
**适用于ubuntu系统**
<br>用法：
```
curl -O https://raw.githubusercontent.com/WavesMan/auto_bash/main/自动化镜像源/update_mirrors.sh && bash update_mirrors.sh
```


## 本地代理工具
**适用于ubuntu系统**
<br>下载：
```
curl -O https://raw.githubusercontent.com/WavesMan/auto_bash/main/本地代理工具/proxy.sh
```
用法：
```
bash proxy.sh
```


## 生电服务端自动下载
~~计划应用于所有系统版本~~
<br>但是现在只支持ubuntu
<br>用法：
```
curl -OL https://raw.githubusercontent.com/WavesMan/auto_bash/main/生电服务端自动下载/start.sh && bash start.sh
```