udev rules for some WWAN modems
===============================

`99-wwan.rules` defines udev rules for some 3G/UMTS/LTE modems.  It
addresses the issue that the ttyUSB devices are numbered randomly, and
their numbering can vary between server reboots.  These rules create
persistent symlinks which can be reliably used in WWAN interface startup
scripts.

These rules assume that there is only one WWAN modem in the system. In
order to address multiple WWAN cards, the rules need to be more
specific and associate with serial numbers of the modems.

Also `99-usb-serial.rules` defines rules for some USB serial adapters,
in order to create persistent symlinks for each serial port.


Also Debian configuration instructionns are listed for some WWAN
modems. They are made for Sunrise UMTS network in Switzerland, and you
may need to modify the APN name for your network.




Copyright (c) 2016 Stanislav Sinyagin <ssinyagin@k-open.com>.

This content is published under Creative Commons Attribution 4.0
International (CC BY 4.0) lincense.

Source repository: https://github.com/ssinyagin/wwan_udev_rules

