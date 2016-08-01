# Setting up a Qualcomm Gobi 2000 WWAN card in Debian 8.
# Assuming that the PIN authentication is disabled on the SIM card.

# Copyright (c) 2016 Stanislav Sinyagin <ssinyagin@k-open.com>.

# This content is published under Creative Commons Attribution 4.0
# International (CC BY 4.0) lincense.

# Source repository: https://github.com/ssinyagin/wwan_udev_rules


apt-get install -y ppp gobi-loader wvdial

wget -O /etc/udev/rules.d/99-wwan.rules \
  https://raw.githubusercontent.com/ssinyagin/wwan_udev_rules/master/99-wwan.rules

mkdir /lib/firmware/gobi
cd /lib/firmware/gobi
wget --no-check-certificate -nd -nc https://www.nerdstube.de/lenovo/treiber/gobi/{amss.mbn,apps.mbn,UQCN.mbn}

cat >/etc/wvdial.conf <<'EOT'
[Dialer Defaults]
Init1 = ATZ
Init2 = ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0
Init3 = AT+CGDCONT=1,"IP","internet"
Phone = *99#
New PPPD = yes
Modem = /dev/ttyGOBI02
Dial Command = ATDT
Baud = 9600
Username = ''
Password = ''
Ask Password = 0
Stupid Mode = 1
Compuserve = 0
Idle Seconds = 0
ISDN = 0
Auto DNS = 1
EOT

cat >/etc/network/interfaces.d/ppp0 <<'EOT'
auto ppp0
iface ppp0 inet wvdial
EOT

