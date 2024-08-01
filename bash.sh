printf '\033c'
echo "Script Started ! Ubuntu 24.04 is recommended"

read -p "BBR - Update [y/n]" answer
if [[ $answer = y ]] ; then
  > /etc/sysctl.conf
  echo "net.core.default_qdisc = fq_codel" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
  echo "sysctl -p" >> /etc/profile
  apt update -y
  apt upgrade -y
fi

read -p "Install XMPlus-NoRelay [y/n]" answer
if [[ $answer = y ]] ; then
  bash <(curl -Ls https://raw.githubusercontent.com/XMPlusDev/XMPlus-NoRelay/install/install.sh)
  vim /etc/XMPlus/config.yml
  vim /etc/XMPlus/dns.json
  vim /etc/XMPlus/route.json
  vim /etc/XMPlus/outbound.json
  vim /etc/XMPlus/node1.crt
  vim /etc/XMPlus/node1.key
  vim /etc/XMPlus/node2.crt
  vim /etc/XMPlus/node2.key
  XMPlus restart
fi

read -p "Setup Hetzner's Floating IP [y/n]" answer
if [[ $answer = y ]] ; then
  echo "Enter the floating ip: "
  read floatingip
  echo "network:" >> /etc/netplan/60-floating-ip.yaml
  echo "   version: 2" >> /etc/netplan/60-floating-ip.yaml
  echo "   renderer: networkd" >> /etc/netplan/60-floating-ip.yaml
  echo "   ethernets:" >> /etc/netplan/60-floating-ip.yaml
  echo "     eth0:" >> /etc/netplan/60-floating-ip.yaml
  echo "       addresses:" >> /etc/netplan/60-floating-ip.yaml
  echo "       - $floatingip/32" >> /etc/netplan/60-floating-ip.yaml
  netplan apply
fi

read -p "Reboot [y/n]" answer
if [[ $answer = y ]] ; then
  echo "Rebooting The Server !"
  reboot
fi
