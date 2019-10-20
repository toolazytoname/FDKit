#!/bin/sh
#example ./

# router_package_install.sh koolproxy  http://www.17luyouqi.com/download/merlin/mips/koolproxy.tar.gz
# router_package_install.sh shadowsocks https://raw.githubusercontent.com/hq450/fancyss_history_package/master/fancyss_arm/shadowsocks_4.1.7.tar.gz

package_name=$1
package_url=$2


cd /tmp
wget -N -O ${package_name}.tar.gz ${package_url}
tar -zxvf /tmp/${package_name}.tar.gz
chmod +x /tmp/${package_name}/install.sh
sh /tmp/${package_name}/install.sh
reboot