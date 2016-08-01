# Setting up a Novatel Wireless, Inc. Expedite E371 WWAN card in
# Debian 8
# Assuming that the PIN authentication is disabled on the SIM card.

# Copyright (c) 2016 Stanislav Sinyagin <ssinyagin@k-open.com>.

# This content is published under Creative Commons Attribution 4.0
# International (CC BY 4.0) lincense.

# Source repository: https://github.com/ssinyagin/wwan_udev_rules



cat >/etc/chatscripts/lte_on.E371 <<'EOT'
ABORT BUSY
ABORT 'NO CARRIER'
ABORT ERROR
TIMEOUT 10
'' ATZ
OK 'AT+CFUN=1'
OK 'AT+CMEE=1'
OK 'AT\$NWQMICONNECT=,,'
OK
EOT

cat >/etc/chatscripts/lte_off.E371 <<'EOT'
ABORT ERROR
TIMEOUT 5
'' AT\$NWQMIDISCONNECT OK
AT+CFUN=0 OK
EOT

cat >/etc/network/interfaces.d/wwan0 <<'EOT'
allow-hotplug wwan0
iface wwan0 inet dhcp
    pre-up /usr/sbin/chat -v -f /etc/chatscripts/lte_on.E371 >/dev/ttyUSB0 </dev/ttyUSB0
    post-down /usr/sbin/chat -v -f /etc/chatscripts/lte_off.E371 >/dev/ttyUSB0 </dev/ttyUSB0
EOT
