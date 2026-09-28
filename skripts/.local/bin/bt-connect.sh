#!/bin/bash
# Connect to NAP
sudo dbus-send --system --print-reply --dest=org.bluez \
  /org/bluez/hci0/dev_F4_4E_FC_99_C9_10 \
  org.bluez.Network1.Connect string:'nap'
sleep 2
# Configure interface
sudo ip link set bnep0 up
sudo ip addr add 192.168.200.2/24 dev bnep0 2>/dev/null
sudo ip route add default via 192.168.200.1 dev bnep0 2>/dev/null
# Disconnect WiFi
nmcli device disconnect wlo1
# DNS
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
echo "Done! Connected via Bluetooth."
