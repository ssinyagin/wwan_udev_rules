# Setting up a Huawei SIMCom SIM7100 WWAN card in Debian 8 or 9.
# Assuming that the PIN authentication is disabled on the SIM card.

# Copyright (c) 2017 Stanislav Sinyagin <ssinyagin@k-open.com>.

# This content is published under Creative Commons Attribution 4.0
# International (CC BY 4.0) lincense.

# Source repository: https://github.com/ssinyagin/wwan_udev_rules


apt-get install -y ppp wvdial

wget -O /etc/udev/rules.d/99-wwan.rules \
  https://raw.githubusercontent.com/ssinyagin/wwan_udev_rules/master/99-wwan.rules

cat >/etc/chatscripts/sunrise.SIM7100 <<'EOT'
ABORT BUSY
ABORT 'NO CARRIER'
ABORT ERROR
TIMEOUT 10
'' ATZ
OK 'AT+CFUN=1'
OK 'AT+CMEE=1'
OK 'AT+CGDCONT=1,"IP","internet"'
OK 'AT\$QCRMCALL=1,1'
\$QCRMCALL:
EOT

cat >/etc/chatscripts/gsm_off.SIM7100 <<'EOT'
ABORT ERROR
TIMEOUT 5
'' AT+CFUN=0 OK
EOT

cat >/etc/network/interfaces.d/lte0 <<'EOT'
allow-hotplug lte0
iface lte0 inet dhcp
    pre-up /usr/sbin/chat -v -f /etc/chatscripts/sunrise.SIM7100 >/dev/ttyWWAN02 </dev/ttyWWAN02
    post-down /usr/sbin/chat -v -f /etc/chatscripts/gsm_off.SIM7100 >/dev/ttyWWAN02 </dev/ttyWWAN02
EOT
