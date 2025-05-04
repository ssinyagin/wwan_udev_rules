# Setting up a Huawei ME909s-120 WWAN card in Ubuntu with Netplan
# Assuming that the PIN authentication is disabled on the SIM card.

# Copyright (c) 2016-2025 Stanislav Sinyagin <ssinyagin@k-open.com>.

# This content is published under Creative Commons Attribution 4.0
# International (CC BY 4.0) lincense.

# Source repository: https://github.com/ssinyagin/wwan_udev_rules


apt-get install -y ppp networkd-dispatcher

wget -O /etc/udev/rules.d/99-wwan.rules \
  https://raw.githubusercontent.com/ssinyagin/wwan_udev_rules/master/99-wwan.rules

cat >/etc/chatscripts/sunrise.HUAWEI <<'EOT'
ABORT BUSY
ABORT 'NO CARRIER'
ABORT ERROR
TIMEOUT 10
'' ATZ
OK 'AT+CFUN=1'
OK 'AT+CMEE=1'
OK 'AT\^NDISDUP=1,1,"internet"'
OK
EOT

cat >/etc/chatscripts/gsm_off.HUAWEI <<'EOT'
ABORT ERROR
TIMEOUT 5
'' AT+CFUN=0 OK
EOT

mkdir -p /etc/networkd-dispatcher/configuring.d/
cat >/etc/networkd-dispatcher/configuring.d/lte0_configuring <<'EOT'
#!/bin/sh
if [ x$IFACE = 'xlte0' ]; then
  /usr/sbin/chat -v -f /etc/chatscripts/sunrise.HUAWEI >/dev/ttyWWAN02 </dev/ttyWWAN02
fi
EOT
chmod 755 /etc/networkd-dispatcher/configuring.d/lte0_configuring

cat >/etc/networkd-dispatcher/off.d/lte0_off <<'EOT'
#!/bin/sh
if [ x$IFACE = 'xlte0' ]; then
  /usr/sbin/chat -v -f /etc/chatscripts/gsm_off.HUAWEI >/dev/ttyWWAN02 </dev/ttyWWAN02
fi
EOT
chmod 755 /etc/networkd-dispatcher/off.d/lte0_off

cat >/etc/netplan/90-lte0.yaml <<'EOT'
network:
  version: 2
  renderer: networkd
  ethernets:
    lte0:
      dhcp4: yes
      dhcp6: yes
      ipv6-privacy: yes
      dhcp4-overrides:
        route-metric: 100
      dhcp6-overrides:
        route-metric: 100
EOT
chmod 600 /etc/netplan/90-lte0.yaml


