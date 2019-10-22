#!/bin/sh
#example 
# wget https://raw.githubusercontent.com/toolazytoname/FDKit/master/FDKit/Shell/RouterShell/router_package_install.sh

# chmod +x router_package_install.sh

# 66
# ./router_package_install.sh shadowsocks http://www.17luyouqi.com/download/merlin/mips/shadowsocks.tar.gz
# ./router_package_install.sh shadowsocks https://github.com/toolazytoname/FDKit/raw/master/FDKit/Shell/RouterShell/package/66/shadowsocks.tar.gz
# 87
# ./router_package_install.sh koolproxy  https://github.com/toolazytoname/FDKit/raw/master/FDKit/Shell/RouterShell/package/87/koolproxy.tar.gz
# ./router_package_install.sh shadowsocks https://github.com/toolazytoname/FDKit/raw/master/FDKit/Shell/RouterShell/package/87/shadowsocks_4.1.7.tar.gz

package_name=$1
package_url=$2


cd /tmp
wget -N -O ${package_name}.tar.gz ${package_url}
tar -zxvf /tmp/${package_name}.tar.gz
if [ -e /tmp/${package_name}/install.sh ]; then
    echo "install.sh  exist"
    chmod +x /tmp/${package_name}/install.sh
    sh /tmp/${package_name}/install.sh
    reboot
else
    echo "install.sh not exist"
fi
