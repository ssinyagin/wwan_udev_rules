# Setting up a Huawei ME909s-120 WWAN card in Debian 8.
# Assuming that the PIN authentication is disabled on the SIM card.

# Copyright (c) 2016 Stanislav Sinyagin <ssinyagin@k-open.com>.

# This content is published under Creative Commons Attribution 4.0
# International (CC BY 4.0) lincense.

# Source repository: https://github.com/ssinyagin/wwan_udev_rules


apt-get install -y ppp 

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

cat >/etc/network/interfaces.d/umts0 <<'EOT'
allow-hotplug umts0
iface umts0 inet dhcp
    pre-up /usr/sbin/chat -v -f /etc/chatscripts/sunrise.HUAWEI >/dev/ttyWWAN02 </dev/ttyWWAN02
    post-down /usr/sbin/chat -v -f /etc/chatscripts/gsm_off.HUAWEI >/dev/ttyWWAN02 </dev/ttyWWAN02
EOT
