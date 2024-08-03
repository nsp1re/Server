printf '\033c'
echo "Script Started ! Ubuntu 24.04 ONLY"

read -p "BBR - Update [y/n]" answer
if [[ $answer = y ]] ; then
  > /etc/sysctl.conf
  echo "net.core.default_qdisc = fq_codel" >> /etc/sysctl.conf
  echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
  echo "sysctl -p" >> /etc/profile
  echo "ulimit -c unlimited" >> /etc/profile
  echo "ulimit -d unlimited" >> /etc/profile
  echo "ulimit -f unlimited" >> /etc/profile
  echo "ulimit -i unlimited" >> /etc/profile
  echo "ulimit -l unlimited" >> /etc/profile
  echo "ulimit -m unlimited" >> /etc/profile
  echo "ulimit -n 1048576" >> /etc/profile
  echo "ulimit -q unlimited" >> /etc/profile
  echo "ulimit -s -H 65536" >> /etc/profile
  echo "ulimit -s 32768" >> /etc/profile
  echo "ulimit -t unlimited" >> /etc/profile
  echo "ulimit -u unlimited" >> /etc/profile
  echo "ulimit -v unlimited" >> /etc/profile
  echo "ulimit -x unlimited" >> /etc/profile
  apt update -y
  apt upgrade -y
fi

read -p "Install XMPlus-NoRelay [y/n]" answer
if [[ $answer = y ]] ; then
  bash <(curl -Ls https://raw.githubusercontent.com/XMPlusDev/XMPlus-NoRelay/install/install.sh)
  echo "Paste config.yml, press ENTER then Ctrl-D to quit"
  > /etc/XMPlus/config.yml
  cat >> /etc/XMPlus/config.yml
  echo "Paste dns.json, press ENTER then Ctrl-D to quit"
  > /etc/XMPlus/dns.json
  cat >> /etc/XMPlus/dns.json
  echo "Paste route.json, press ENTER then Ctrl-D to quit"
  > /etc/XMPlus/route.json
  cat >> /etc/XMPlus/route.json
  echo "Paste outbound.json, press ENTER then Ctrl-D to quit"
  > /etc/XMPlus/outbound.json
  cat >> /etc/XMPlus/outbound.json
  echo "Paste node1.crt, press ENTER then Ctrl-D to quit"
  cat >> /etc/XMPlus/node1.crt
  echo "Paste node1.key, press ENTER then Ctrl-D to quit"
  cat >> /etc/XMPlus/node1.key
  read -p "Node 2 [y/n]" answer
  if [[ $answer = y ]] ; then
    echo "Paste node2.crt, press ENTER then Ctrl-D to quit"
    cat >> /etc/XMPlus/node2.crt
    echo "Paste node2.key, press ENTER then Ctrl-D to quit"
    cat >> /etc/XMPlus/node2.key
  fi
  XMPlus restart
fi

read -p "Install Marzban [y/n]" answer
if [[ $answer = y ]] ; then
  bash -c "$(curl -sL https://github.com/Gozargah/Marzban-scripts/raw/master/marzban.sh)" @ install
  read -p " Create a sudo admin [y/n]" answer
  if [[ $answer = y ]] ; then
    marzban cli admin create --sudo
  fi
fi

read -p "Install Marzban-Node [y/n]" answer
if [[ $answer = y ]] ; then
  apt install -y curl socat git
  curl -fsSL https://get.docker.com | sh
  git clone https://github.com/Gozargah/Marzban-node
  mkdir /var/lib/marzban-node
  echo "Paste docker-compose.yml, press ENTER then Ctrl-D to quit"
  > ~/Marzban-node/docker-compose.yml
  cat >> ~/Marzban-node/docker-compose.yml
  echo "Paste ssl_client_cert.pem, press ENTER then Ctrl-D to quit"
  cat >> /var/lib/marzban-node/ssl_client_cert.pem
  cd ~/Marzban-node
  docker compose up -d
fi

read -p "Hetzner's floating ip [y/n]" answer
if [[ $answer = y ]] ; then
  echo "Enter server's floating ip, press ENTER to quit"
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
  echo "Rebooting the server !"
  reboot
fi
