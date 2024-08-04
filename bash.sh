printf '\033c'
echo "Script started !"

read -p "Network optimizations - System update [y/n]" answer
if [[ $answer = y ]] ; then
  if [ grep -q unlimited "/etc/profile" ]; then
    echo "Network is already optimized, skipping"
  fi
  if [ ! grep -q unlimited "/etc/profile" ]; then
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
  fi
  apt update -y
  apt upgrade -y
fi

read -p "Install XMPlus-NoRelay [y/n]" answer
if [[ $answer = y ]] ; then
  if [ -d "/etc/XMPlus/" ]; then
    echo "XMPlus-NoRelay is already installed, skipping"
  fi
  if [ ! -d "/etc/XMPlus/" ]; then
    bash <(curl -Ls https://raw.githubusercontent.com/XMPlusDev/XMPlus-NoRelay/install/install.sh)
    echo "Paste your config.yml, press ENTER then Ctrl-D to save"
    > /etc/XMPlus/config.yml
    cat >> /etc/XMPlus/config.yml
    echo "Paste your dns.json, press ENTER then Ctrl-D to save"
    > /etc/XMPlus/dns.json
    cat >> /etc/XMPlus/dns.json
    echo "Paste your route.json, press ENTER then Ctrl-D to save"
    > /etc/XMPlus/route.json
    cat >> /etc/XMPlus/route.json
    echo "Paste your outbound.json, press ENTER then Ctrl-D to save"
    > /etc/XMPlus/outbound.json
    cat >> /etc/XMPlus/outbound.json
    echo "Paste your node1.crt, press ENTER then Ctrl-D to save"
    > /etc/XMPlus/node1.crt
    cat >> /etc/XMPlus/node1.crt
    echo "Paste your node1.key, press ENTER then Ctrl-D to save"
    > /etc/XMPlus/node1.key
    cat >> /etc/XMPlus/node1.key
    read -p "Node 2 [y/n]" answer
    if [[ $answer = y ]] ; then
      echo "Paste your node2.crt, press ENTER then Ctrl-D to save"
      > /etc/XMPlus/node2.crt
      cat >> /etc/XMPlus/node2.crt
      echo "Paste your node2.key, press ENTER then Ctrl-D to save"
      > /etc/XMPlus/node2.key
      cat >> /etc/XMPlus/node2.key
    fi
    XMPlus restart
  fi
fi

read -p "Install Marzban [y/n]" answer
if [[ $answer = y ]] ; then
  if [ -d "/opt/marzban/" ]; then
    echo "Marzban is already installed, skipping"
  fi
  if [ ! -d "/opt/marzban/" ]; then
    bash -c "$(curl -sL https://github.com/Gozargah/Marzban-scripts/raw/master/marzban.sh)" @ install
  fi
  read -p "Create a sudo admin [y/n]" answer
  if [[ $answer = y ]] ; then
    marzban cli admin create --sudo
  fi
  read -p "Edit /opt/marzban/.env [y/n]" answer
  if [[ $answer = y ]] ; then
    nano /opt/marzban/.env
    marzban restart -n
  fi
fi

read -p "Install Marzban-Node [y/n]" answer
if [[ $answer = y ]] ; then
  if [ -d "~/Marzban-node/" ]; then
    echo "Marzban-Node is already installed, skipping"
  fi
  if [ ! -d "~/Marzban-node/" ]; then
    apt install -y curl socat git
    curl -fsSL https://get.docker.com | sh
    git clone https://github.com/Gozargah/Marzban-node
    mkdir /var/lib/marzban-node
    echo "Paste your docker-compose.yml, press ENTER then Ctrl-D to save"
    > ~/Marzban-node/docker-compose.yml
    cat >> ~/Marzban-node/docker-compose.yml
    echo "Paste your ssl_client_cert.pem, press ENTER then Ctrl-D to save"
    > /var/lib/marzban-node/ssl_client_cert.pem
    cat >> /var/lib/marzban-node/ssl_client_cert.pem
    cd ~/Marzban-node
    docker compose up -d
    cd
  fi
fi

read -p "Add hetzner's floating ip [y/n]" answer
if [[ $answer = y ]] ; then
  echo "Paste your server's floating ip, press ENTER to save"
  read floatingip
  > /etc/netplan/60-floating-ip.yaml
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
