#!/usr/bin/env bash

# 定义 UUID 及伪装路径、哪吒面板参数，请自行修改. (注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
UUID='1b123375-7772-48bb-a2a1-a6848209d3a1'
VMESS_WSPATH='/vmbeauty23'
VLESS_WSPATH='/vlbeauty22'
TROJAN_WSPATH='/trbeauty24'
SS_WSPATH='/shadowbeauty25'
NEZHA_SERVER=''
NEZHA_PORT=''
NEZHA_KEY=''
sed -i "s#UUID#$UUID#g;s#VMESS_WSPATH#${VMESS_WSPATH}#g;s#VLESS_WSPATH#${VLESS_WSPATH}#g;s#TROJAN_WSPATH#${TROJAN_WSPATH}#g;s#SS_WSPATH#${SS_WSPATH}#g" config.json
sed -i "s#VMESS_WSPATH#${VMESS_WSPATH}#g;s#VLESS_WSPATH#${VLESS_WSPATH}#g;s#TROJAN_WSPATH#${TROJAN_WSPATH}#g;s#SS_WSPATH#${SS_WSPATH}#g" /etc/nginx/nginx.conf
sed -i "s#RELEASE_RANDOMNESS#${RELEASE_RANDOMNESS}#g" /etc/supervisor/conf.d/supervisord.conf

# 设置 nginx 伪装站
rm -rf /usr/share/nginx/*
wget https://github.com/happyevero/Html/raw/main/S-html.zip -O /usr/share/nginx/S-html.zip
unzip -o "/usr/share/nginx/S-html.zip" -d /usr/share/nginx/html
rm -f /usr/share/nginx/S-html.zip

# 伪装 xray 执行文件
RELEASE_RANDOMNESS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 6)
mv xray ${RELEASE_RANDOMNESS}
wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat
wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat
cat config.json | base64 > config
rm -f config.json

# 如果有设置哪吒探针三个变量,会安装。如果不填或者不全,则不会安装
[ -n "${NEZHA_SERVER}" ] && [ -n "${NEZHA_PORT}" ] && [ -n "${NEZHA_KEY}" ] && wget https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -O nezha.sh && chmod +x nezha.sh && ./nezha.sh install_agent ${NEZHA_SERVER} ${NEZHA_PORT} ${NEZHA_KEY}

nginx
base64 -d config > config.json
./${RELEASE_RANDOMNESS} -config=config.json
