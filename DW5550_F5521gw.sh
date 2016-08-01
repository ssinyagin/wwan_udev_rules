# Setting up a Dell DW5550 (or Ericsson F5521gw) WWAN card in
# Debian 8.
# Assuming that the PIN authentication is disabled on the SIM card.

# Copyright (c) 2016 Stanislav Sinyagin <ssinyagin@k-open.com>.

# This content is published under Creative Commons Attribution 4.0
# International (CC BY 4.0) lincense.

# Source repository: https://github.com/ssinyagin/wwan_udev_rules

# The kernel installs the TTY devices as /dev/ttyACM[012], so there's no
# need to set up udev rules to recognize the modem from other ttyUSB
# devices.

apt-get install -y ppp

cat >/etc/chatscripts/sunrise.DW5550 <<'EOT'
ABORT BUSY
ABORT 'NO CARRIER'
ABORT ERROR
TIMEOUT 10
'' AT+CFUN=1 OK
\dAT+CGDCONT=1,"IP","internet" OK
\d\d\dAT*ENAP=1,1 OK
EOT

cat >/etc/chatscripts/gsm_off.DW5550 <<'EOT'
ABORT ERROR
TIMEOUT 5
'' AT+CFUN=4 OK
EOT


cat >/etc/network/interfaces.d/wwan0 <<'EOT'
allow-hotplug wwan0
iface wwan0 inet dhcp
    pre-up /usr/sbin/chat -v -f /etc/chatscripts/sunrise.DW5550 >/dev/ttyACM0 </dev/ttyACM0
    post-down /usr/sbin/chat -v -f /etc/chatscripts/gsm_off.DW5550 >/dev/ttyACM0 </dev/ttyACM0
EOT
