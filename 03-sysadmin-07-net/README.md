# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

```
ip -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
eth0             UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>
```
```
ip -br address
lo               UNKNOWN        127.0.0.1/8 ::1/128 
eth0             UP             10.0.2.15/24 fe80::a00:27ff:feb1:285d/64
```
```
netsh interface show interface

Состояние адм.  Состояние     Тип              Имя интерфейса
---------------------------------------------------------------------
Разрешен       Отключен       Выделенный       Ethernet 2
Разрешен       Отключен       Выделенный       Ethernet 3
Разрешен       Подключен      Выделенный       VirtualBox Host-Only Network
Разрешен       Подключен      Выделенный       Беспроводная сеть
Разрешен       Отключен       Выделенный       Ethernet 4
```

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

LLDP – информация о соседнем устройстве.

LLDP – протокол для обмена информацией между соседними устройствами, позволяет определить к какому порту коммутатора подключен сервер.

Пакет lldpd

У меня нет соседних устройств
```
lldpctl
-------------------------------------------------------------------------------
LLDP neighbors:
-------------------------------------------------------------------------------
```

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

VLAN – виртуальное разделение коммутатора.

Пакет vlan

Чтобы использовать VLAN, потребуется:
 - Коммутатор с поддержкой стандарта IEEE 802.1q в сети Ethernet.
 - Сетевая карта, которая работает с Linux и поддерживает стандарт 802.1q .

Сделаем все необходимое перед тем, как начнем настройку vlan.
```
sudo modprobe 8021q
lsmod | grep 8021q
8021q                  32768  0
garp                   16384  1 8021q
mrp                    20480  1 8021q
```
Прописываем конфигурацию
```
sudo nano /etc/network/interfaces
# vlan с ID-100 для интерфейса eth0
# «поднимать» интерфейс при запуске сетевой службы
auto eth0.100
# название интерфейса
iface eth0.100 inet static
address 192.168.1.200
netmask 255.255.255.0
# указывает на каком физическом интерфейсе создавать VLAN.
vlan-raw-device eth0
```
Перезапускаем службу networking
```
sudo systemctl restart networking.service
```
```
ip -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
eth0             UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>
eth0.100@eth0    UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>
```

Попробовал и другим способом
```
sudo ip link add link eth0 name eth0.10 type vlan id 10
ip -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
eth0             UP             08:00:27:b1:28:5d <BROADCAST,MULTICAST,UP,LOWER_UP>
eth0.10@eth0     DOWN           08:00:27:b1:28:5d <BROADCAST,MULTICAST>
```
```
ip -d link show eth0.10
3: eth0.10@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 0 maxmtu 65535
    vlan protocol 802.1Q id 10 <REORDER_HDR> addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535

```
```
ip -br address
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.0.2.15/24 fe80::a00:27ff:feb1:285d/64
eth0.10@eth0     DOWN
```
Теперь присвоим IP, и включим устройство
```
# sudo ip addr add 192.168.1.200/24 brd 192.168.1.255 dev eth0.10
# sudo ip link set dev eth0.10 up
```
```
ip -br address
lo               UNKNOWN        127.0.0.1/8 ::1/128 
eth0             UP             10.0.2.15/24 fe80::a00:27ff:feb1:285d/64
eth0.10@eth0     UP             192.168.1.200/24 fe80::a00:27ff:feb1:285d/64
```

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

LAG:
- статический (на Cisco mode on);
- динамический – LACP протокол (на Cisco mode active)

```
lsmod | grep bonding
bonding               167936  0
```
Чтобы настроить bound, воспользуемся двумя доступными интерфейсами eth0 eth1
```
sudo nano /etc/network/interfaces
auto bond0
iface bond0 inet static
	address 192.168.1.150
	netmask 255.255.255.0	
	gateway 192.168.1.1
	network 192.168.1.0
	dns-nameservers 192.168.1.1 8.8.8.8
	dns-search domain.local
		slaves eth0 eth1
		bond_mode 0
		bond-miimon 100
		bond_downdelay 200
		bond_updelay 200
```
Перезапускаем службу networking
```
sudo systemctl restart networking.service
```
```
sudo ip -br link | grep bond0
bond0            UP           82:65:6a:ad:bf:81 <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP>
```

address - ip адрес для bond0
netmask - маска сети для bond0
gateway - шлюз по умолчанию для bond0.
network - сетевой адрес для bond0.
dns-nameservers - DNS сервера
slaves - интерфейсы, которые будут объединены логически в один
bond_mode - существует 7 модов, я выбрал 0 - тип соединения по умолчанию, перебирает от первого интерфейса к последнему
bond-miimon - Это значение определяет как часто будет проверяться состояние соединения на каждом из интерфейсов
bond-downdelay - Устанавливает время в 200 миллисекунд ожидания, прежде чем отключить slave в случае отказа соединения
bond_updelay - Устанавливает время в 200 миллисекунд ожидания, прежде чем включить slave после восстановления соединения

5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

```
ipcalc 192.168.0.1/29
Address:   192.168.0.1          11000000.10101000.00000000.00000 001
Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111
=>
Network:   192.168.0.0/29       11000000.10101000.00000000.00000 000
HostMin:   192.168.0.1          11000000.10101000.00000000.00000 001
HostMax:   192.168.0.6          11000000.10101000.00000000.00000 110
Broadcast: 192.168.0.7          11000000.10101000.00000000.00000 111
Hosts/Net: 6                     Class C, Private Internet
```
Вычисляется при помощи формулы 2^n-2, где '-2' - это сама сеть, самое первое числа, и самое последнее число, широковещательный канал, они зарезервированы, все остальное можно в хосты реализовать

В нашем случае n = 3

2^3-2=6. 

Получается, чтобы создать подсеть с маской /29 нужно 8 адресов (2 необходимых и 6 для хостов), а в маске /24 их 256 (2 необходимых и 254 хостов)

256 / 8 = 32 подсети, 32 x 6 = 192 хоста

Выведем деление для первых 3
```
ipcalc -b 10.10.10.0/24 -s 6 6 6
Address:   10.10.10.0
Netmask:   255.255.255.0 = 24
Wildcard:  0.0.0.255
=>
Network:   10.10.10.0/24
HostMin:   10.10.10.1
HostMax:   10.10.10.254
Broadcast: 10.10.10.255
Hosts/Net: 254                   Class A, Private Internet

1. Requested size: 6 hosts
Netmask:   255.255.255.248 = 29
Network:   10.10.10.0/29
HostMin:   10.10.10.1
HostMax:   10.10.10.6
Broadcast: 10.10.10.7
Hosts/Net: 6                     Class A, Private Internet

2. Requested size: 6 hosts
Netmask:   255.255.255.248 = 29
Network:   10.10.10.8/29
HostMin:   10.10.10.9
HostMax:   10.10.10.14
Broadcast: 10.10.10.15
Hosts/Net: 6                     Class A, Private Internet

3. Requested size: 6 hosts
HostMin:   10.10.10.17
HostMax:   10.10.10.22
Broadcast: 10.10.10.23
Hosts/Net: 6                     Class A, Private Internet

Needed size:  24 addresses.
```

6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

Исходя из ipv4 частных сетей, существует ещё вариант

100.64.0.0 — 100.127.255.255 (маска подсети: 255.192.0.0 или /10) Carrier-Grade NAT.

Посмотрим для 40 хостов
```
ipcalc -b 100.64.0.0/10 -s 40
Address:   100.64.0.0           
Netmask:   255.192.0.0 = 10
Wildcard:  0.63.255.255
=>
Network:   100.64.0.0/10
HostMin:   100.64.0.1
HostMax:   100.127.255.254
Broadcast: 100.127.255.255
Hosts/Net: 4194302               Class A

1. Requested size: 40 hosts
Netmask:   255.255.255.192 = 26
Network:   100.64.0.0/26
HostMin:   100.64.0.1
HostMax:   100.64.0.62
Broadcast: 100.64.0.63
Hosts/Net: 62                    Class A

Needed size:  64 addresses.
Used network: 100.64.0.0/26
```
Посмотрим для 50 хостов
```
ipcalc -b 100.64.0.0/10 -s 50
Address:   100.64.0.0           
Netmask:   255.192.0.0 = 10     
Wildcard:  0.63.255.255         
=>
Network:   100.64.0.0/10        
HostMin:   100.64.0.1           
HostMax:   100.127.255.254
Broadcast: 100.127.255.255
Hosts/Net: 4194302               Class A

1. Requested size: 50 hosts
Netmask:   255.255.255.192 = 26
Network:   100.64.0.0/26
HostMin:   100.64.0.1
HostMax:   100.64.0.62
Broadcast: 100.64.0.63
Hosts/Net: 62                    Class A

Needed size:  64 addresses.
Used network: 100.64.0.0/26
```
Указывает на одну и туже маску - /26

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

Посмотрим таблицу
```
arp
Address                  HWtype  HWaddress           Flags Mask            Iface
10.0.2.3                 ether   52:54:00:12:35:03   C                     eth0
_gateway                 ether   52:54:00:12:35:02   C                     eth0
```

Удалим одну запись
```
sudo arp -d 10.0.2.3
arp
Address                  HWtype  HWaddress           Flags Mask            Iface
_gateway                 ether   52:54:00:12:35:02   C                     eth0
_gateway                 ether   52:54:00:12:35:02   C                     eth0
```

Удалим все
```
sudo ip neigh flush all
```

Для windows просмотр
```
arp -a

Интерфейс: 192.168.0.147 --- 0x11
  адрес в Интернете      Физический адрес      Тип
  192.168.0.1           0c-80-63-f0-9f-24     динамический
  192.168.0.255         ff-ff-ff-ff-ff-ff     статический
  224.0.0.2             01-00-5e-00-00-02     статический
  224.0.0.22            01-00-5e-00-00-16     статический
  224.0.0.251           01-00-5e-00-00-fb     статический
  224.0.0.252           01-00-5e-00-00-fc     статический
  239.255.255.250       01-00-5e-7f-ff-fa     статический
  255.255.255.255       ff-ff-ff-ff-ff-ff     статический

Интерфейс: 192.168.56.1 --- 0x14
  адрес в Интернете      Физический адрес      Тип
  192.168.56.255        ff-ff-ff-ff-ff-ff     статический
  224.0.0.2             01-00-5e-00-00-02     статический
  224.0.0.22            01-00-5e-00-00-16     статический
  224.0.0.251           01-00-5e-00-00-fb     статический
  224.0.0.252           01-00-5e-00-00-fc     статический
  239.255.255.250       01-00-5e-7f-ff-fa     статический
  255.255.255.255       ff-ff-ff-ff-ff-ff     статический

Интерфейс: 172.29.128.1 --- 0x1c
  адрес в Интернете      Физический адрес      Тип
  172.29.143.255        ff-ff-ff-ff-ff-ff     статический
  224.0.0.2             01-00-5e-00-00-02     статический
  224.0.0.22            01-00-5e-00-00-16     статический
  224.0.0.251           01-00-5e-00-00-fb     статический
  239.255.255.250       01-00-5e-7f-ff-fa     статический
  255.255.255.255       ff-ff-ff-ff-ff-ff     статический
```

Для windows чистка кэша
```
netsh interface ip delete arpcache
```

 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

 8*. Установите эмулятор EVE-ng.
 
 Инструкция по установке - https://github.com/svmyasnikov/eve-ng

 Выполните задания на lldp, vlan, bonding в эмуляторе EVE-ng. 
 
 ---