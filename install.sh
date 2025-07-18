#!/bin/bash

read -p "Enter desired version (leave empty for latest): " input_version

if [[ -z "$input_version" ]]; then
  xversion="latest"
  urlversion="latest"
else
  xversion="$input_version"
  urlversion="v-$input_version"
fi

echo "Selected version: $xversion"

ARCH=$(uname -m)
case "${ARCH}" in
  x86_64 | x64 | amd64) XUI_ARCH="amd64" ;;
  i*86 | x86) XUI_ARCH="386" ;;
  armv8* | armv8 | arm64 | aarch64) XUI_ARCH="arm64" ;;
  armv7* | armv7) XUI_ARCH="armv7" ;;
  *) XUI_ARCH="amd64" ;;
esac

cd /root/

rm -rf x-ui/ /usr/local/x-ui/ /usr/bin/x-ui

if [ "$xversion" = "latest" ]; then
  wget -O x-ui.tar.gz https://github.com/MHSanaei/3x-ui/releases/latest/download/x-ui-linux-${XUI_ARCH}.tar.gz
else
  wget -O x-ui.tar.gz https://github.com/MHSanaei/3x-ui/releases/download/${urlversion}/x-ui-linux-${XUI_ARCH}.tar.gz
fi

tar zxvf x-ui.tar.gz
chmod +x x-ui/x-ui x-ui/bin/xray-linux-* x-ui/x-ui.sh
cp x-ui/x-ui.sh /usr/bin/x-ui
cp -f x-ui/x-ui.service /etc/systemd/system/
mv x-ui/ /usr/local/

systemctl daemon-reload
systemctl enable x-ui
systemctl restart x-ui

echo "✅ x-ui installation completed successfully."
