#!/bin/bash
# Подключиться к NAP
sudo dbus-send --system --print-reply --dest=org.bluez \
  /org/bluez/hci0/dev_F4_4E_FC_99_C9_10 \
  org.bluez.Network1.Connect string:'nap'
sleep 2
# Настроить интерфейс
sudo ip addr add 192.168.100.2/24 dev enp0s20f0u14 2>/dev/null
sudo ip link set enp0s20f0u14 up
sudo ip route add default via 192.168.100.1 2>/dev/null
# Отключить WiFi
nmcli device disconnect wlo1
# DNS
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
echo "Готово! Интернет через Bluetooth."
