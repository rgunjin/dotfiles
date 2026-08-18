# BNEP Tethering: Alpine VM (Router) → Notebook

Заметка для себя из будущего. Если Bluetooth-тетеринг снова сломался —
читай отсюда по порядку, не начинай гадать заново.

## Схема

    Интернет → eth0 → Alpine VM (Router) → Bluetooth (NAP/pan0) → Notebook (bnep0)

- Сервер: Alpine Linux VM внутри VMware, hostname Router
- Bluetooth-адаптер сервера: USB passthrough, Actions general adapter (VID:PID 10d7:b012)
- MAC сервера: F4:4E:FC:99:C9:10
- MAC ноутбука: 84:5C:F3:C7:28:64
- Клиент: скрипт ~/dotfiles/skripts/bt-connect.sh
- Сервер: скрипт bt-server.sh (в ~ на Router)

## Чек-лист диагностики (по порядку, не пропускай шаги)

### 1. Живой ли Bluetooth-адаптер на сервере вообще?

    lsusb                          # должен быть виден 10d7:b012
    ls /sys/class/bluetooth/       # должен быть hci0
    bluetoothctl list              # должен показать контроллер

Если /sys/class/bluetooth/ пустой, а lsusb не показывает адаптер —
проблема на уровне USB passthrough в VMware, не в софте. Иди к шагу 2.

Если lsusb адаптер видит, а hci0 нет — попробуй:

    rc-service bluetooth restart

### 2. USB passthrough проблема (самая частая причина!)

ГЛАВНЫЙ УРОК: держи USB Controller в настройках VM на USB 1.1.

Этот конкретный Bluetooth-донгл (10d7:b012) стабильно работает только
на USB 1.1 (UHCI). При переключении на USB 2.0 или USB 3.2:
- устройство может вообще пропасть из lsusb внутри VM
- либо появляется, но hciconfig hci0 features виснет с
  Operation timed out (110) — то есть VM физически не может
  стабильно обмениваться HCI-командами с адаптером
- радио-часть отваливается: bluetoothctl scan on не видит вообще
  никого вокруг, хотя Powered: yes и PSCAN ISCAN выставлены

Если USB-контроллер сбился (например, после обновления VMware или
случайного клика):

На хосте (не в Alpine!):
1. VM → Settings → USB Controller → выставить USB 1.1
2. Перезапустить VM
3. VM → Removable Devices → найти адаптер → Connect
   (после смены версии контроллера passthrough-привязка часто слетает
   и её нужно переподключить вручную, даже если lsusb на хосте видит
   устройство)

В Alpine после этого:

    lsusb                     # должен снова появиться 10d7:b012
    ls /sys/class/bluetooth/  # должен быть hci0
    bluetoothctl scan on      # должен видеть окружающие устройства (проверка радио)

Если сервер видит вокруг другие BT-устройства (лампы, часы, mesh-сенсоры
и т.п.) — радио живое, можно двигаться дальше.

### 3. Pairing/Trust (обычно не проблема, но проверь)

На ноуте:

    bluetoothctl info F4:4E:FC:99:C9:10

Должно быть Paired: yes, Bonded: yes, Trusted: yes.
Если нет — запейрить заново (pair → trust в bluetoothctl на обеих
сторонах). Ошибка br-connection-page-timeout при connect — это
СИМПТОМ шага 2 (радио-проблема), не проблема пейринга — если пейринг
уже стоит yes/yes/yes, не трать время на re-pairing, иди чинить USB.

### 4. bt-network падает с assertion error

Текст ошибки:

    ERROR:lib/bluez/adapter.c:165:adapter_get_dbus_object_path: assertion failed: (ADAPTER_IS(self))
    Aborted

Это вылезает, если bt-network стартует в момент, когда hci0 ещё не
существует или только что пересоздался (например, сразу после смены
USB-конфигурации, пока bluetoothd не успел переинициализировать
адаптер). Порядок действий:

    pkill -f "bt-network -s nap pan0"   # убить всё зависшее
    rc-service bluetooth restart
    bluetoothctl list                    # убедиться что hci0 на месте
    bt-network -s nap pan0               # запустить вручную, foreground

Если стартовало без ошибок (просто висит, ничего не печатает) — ок,
можно убивать (Ctrl+C) и запускать через полный bt-server.sh с
watchdog.

## Финальные скрипты

### Сервер: bt-server.sh (запускать на Router)

    #!/bin/sh
    # Kill any leftover process from previous runs
    pkill -f "bt-network -s nap pan0" 2>/dev/null
    sleep 1

    # Remove old bridges
    ip link delete tether 2>/dev/null
    ip link delete pan0 2>/dev/null

    # Create bridge
    ip link add pan0 type bridge
    ip link set pan0 up
    ip addr add 192.168.200.1/24 dev pan0

    # NOTE: не регистрируй NAP вручную через sdptool/dbus-send —
    # bt-network делает это сам. Тройная регистрация = нестабильность.

    # Start NAP server with auto-restart
    (
      while true; do
        bt-network -s nap pan0
        logger -t bt-server "bt-network exited (code $?), restarting in 1s"
        sleep 1
      done
    ) &

    # IP forwarding + NAT (замени eth0, если интерфейс с интернетом другой)
    sysctl -w net.ipv4.ip_forward=1
    iptables -t nat -C POSTROUTING -o eth0 -j MASQUERADE 2>/dev/null || \
      iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

    # Bluetooth visibility and trust
    bluetoothctl power on
    bluetoothctl discoverable on
    bluetoothctl pairable on
    bluetoothctl trust 84:5C:F3:C7:28:64

    echo "Done! NAP server is running."

### Клиент: ~/dotfiles/skripts/bt-connect.sh (запускать на ноуте)

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

## Разовая настройка окружения (уже сделано, но на всякий случай)

На сервере (Alpine):

    apk add iptables
    mkdir -p /etc/iptables
    iptables-save > /etc/iptables/rules-save
    rc-update add iptables default

    # syslog с буфером в памяти, чтобы logread работал
    echo 'SYSLOGD_OPTS="-t -C1024"' > /etc/conf.d/syslog
    rc-service syslog restart

    rc-update add syslog default

## Если снова что-то не так — порядок диагностики

1. lsusb + ls /sys/class/bluetooth/ на сервере — жив ли адаптер
2. Если пусто → USB Controller в VM Settings → USB 1.1, переподключить
   через Removable Devices
3. bluetoothctl scan on на сервере — видит ли он вообще что-то вокруг
   (проверка радио, не софта)
4. bluetoothctl info <MAC> на ноуте — Paired/Bonded/Trusted
5. pkill -f bt-network + bt-network -s nap pan0 вручную на сервере —
   смотрим, не падает ли с assertion
6. bash -x bt-connect.sh на ноуте — построчная трассировка, где именно
   рвётся

Логи на сервере: logread | grep bt-server (падения bt-network пишет
watchdog через logger).
