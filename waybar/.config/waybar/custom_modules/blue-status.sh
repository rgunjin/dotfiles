#!/bin/bash
if bluetoothctl show | grep -q "Powered: yes"; then
    echo '{"text":"󰂯","class":"bluetooth"}'   # Bluetooth включён
else
    echo '{"text":"󰂲","class":"bluetooth off"}' # Bluetooth выключен (перечеркнуто)
fi
