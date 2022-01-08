# 3.7. Компьютерные сети, лекция 2
1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

Windows (сократил вывод):  
- cmd
```
PS D:\VMs\Vagrant> ipconfig /all

Windows IP Configuration

   Host Name . . . . . . . . . . . . : MY-DELL
   Primary Dns Suffix  . . . . . . . :
   Node Type . . . . . . . . . . . . : Hybrid
   IP Routing Enabled. . . . . . . . : No
   WINS Proxy Enabled. . . . . . . . : No

Ethernet adapter Ethernet:

   Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . : WORKGROUP
   Description . . . . . . . . . . . : Контроллер семейства Realtek PCIe GbE
   Physical Address. . . . . . . . . : 50-9A-4C-C5-BF-A6
   DHCP Enabled. . . . . . . . . . . : Yes
   Autoconfiguration Enabled . . . . : Yes

Wireless LAN adapter Беспроводная сеть:

   Connection-specific DNS Suffix  . :
   Description . . . . . . . . . . . : Intel(R) Dual Band Wireless-AC 3165
   Physical Address. . . . . . . . . : CC-2F-71-D8-2C-3C
   DHCP Enabled. . . . . . . . . . . : Yes
   Autoconfiguration Enabled . . . . : Yes
   Link-local IPv6 Address . . . . . : fe80::65a6:28d3:a13:f468%18(Preferred)
   IPv4 Address. . . . . . . . . . . : 192.168.11.216(Preferred)
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Lease Obtained. . . . . . . . . . : 8 января 2022 г. 21:01:50
   Lease Expires . . . . . . . . . . : 9 января 2022 г. 21:33:04
   Default Gateway . . . . . . . . . : 192.168.11.1
   DHCP Server . . . . . . . . . . . : 192.168.11.1
   DHCPv6 IAID . . . . . . . . . . . : 298594161
   DHCPv6 Client DUID. . . . . . . . : 00-01-00-01-21-33-C2-91-50-9A-4C-C5-BF-A6
   DNS Servers . . . . . . . . . . . : 192.168.11.1
                                       192.168.11.1
   NetBIOS over Tcpip. . . . . . . . : Enabled
```
- powershell
```
PS D:\VMs\Vagrant> Get-NetAdapter

Name                      InterfaceDescription                    ifIndex Status       MacAddress
----                      --------------------                    ------- ------       ----------
Беспроводная сеть         Intel(R) Dual Band Wireless-AC 3165          18 Up           CC-2F-71-D8...
Ethernet                  Контроллер семейства Realtek PCIe GbE        16 Disconnected 50-9A-4C-C5...

PS D:\VMs\Vagrant> Get-NetIPConfiguration -InterfaceAlias 'Беспроводная сеть' -Detailed

ComputerName                          : YUTS-DELL
InterfaceAlias                        : Беспроводная сеть
InterfaceIndex                        : 18
InterfaceDescription                  : Intel(R) Dual Band Wireless-AC 3165
NetCompartment.CompartmentId          : 1
NetCompartment.CompartmentDescription : Default Compartment
NetAdapter.LinkLayerAddress           : CC-2F-71-D8-2C-3C
NetAdapter.Status                     : Up
NetProfile.Name                       : WetWarmWormAncestor
NetProfile.NetworkCategory            : Public
NetProfile.IPv6Connectivity           : NoTraffic
NetProfile.IPv4Connectivity           : Internet
IPv6LinkLocalAddress                  : fe80::65a6:28d3:a13:f468%18
IPv4Address                           : 192.168.11.216
IPv6DefaultGateway                    :
IPv4DefaultGateway                    : 192.168.11.1
NetIPv6Interface.NlMTU                : 1500
NetIPv4Interface.NlMTU                : 1500
NetIPv6Interface.DHCP                 : Enabled
NetIPv4Interface.DHCP                 : Enabled
DNSServer                             : 192.168.11.1
                                        192.168.11.1
```

Linux:  
```
vagrant@vagrant:~$ ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
        inet6 fe80::a00:27ff:feb1:285d  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:b1:28:5d  txqueuelen 1000  (Ethernet)
        RX packets 84018  bytes 62880059 (62.8 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 53652  bytes 4687329 (4.6 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 1050  bytes 81750 (81.7 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1050  bytes 81750 (81.7 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

vagrant@vagrant:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 50442sec preferred_lft 50442sec
    inet6 fe80::a00:27ff:feb1:285d/64 scope link
       valid_lft forever preferred_lft forever
```

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу?  
Ответ:  
- CDP (Cisco Discovery Protocol)
- EDP (Extreme Discovery Protocole) и прочие проприетарные...
- LLDP (Link Layer Discovery Protocol)  
Какой пакет и команды есть в Linux для этого?  
Пакет `lldpd`, для работы с которым необходимо запускать `lldpcli`

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей?  
Ответ: VLAN (Virtual Local Area Network)  
Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
Пакет так и называется `vlan`.  
Насчёт комманд: есть `vconfig`, но её всё грозятся перевести в deprecated и предлагают переходить на `ip`. Ниже пример создания vlan 123 для обеих команд:  
```
vconfig add eth0 123
ip link add link eth0 name eth0.123 type vlan id 123
```
И привязка IP:  
```
ip addr add 10.10.123.10/24 dev eth0.123
```
Пример конфига:  
```
auto eth0.123
iface eth0.123 inet static
    address 10.10.123.10
    netmask 255.255.255.0
    gateway 10.10.123.1
    vlan-raw-device eth0
```

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

Ответ:  
Доводилось работать только с deb-based системами так что напишу на примере них.  
Работа агрегации обспечивается модулем bonding, умеющем работать в нескольких режимах:
- 0 или balance-rr - режим циклического выбора активного интерфейса для исходящего трафика;
- 1 или active-backup - активен один интерфейс, остальные в горячей замене;
- 2 или balance-xor - каждый получатель закрепляется за одним из физических интерфейсов, который выбирается по специальной формуле;
- 3 или broadcast - трафик идет через все интерфейсы одновременно;
- 4 или 802.3ad - в bond объединяются одинаковые по скорости и режиму интерфейсы. Все физические интерфейсы используются одновременно в соответствии со спецификацией IEEE 802.3ad (Необходим коммутатор, поддерживающий стандарт IEEE 802.3ad);
- 5 или balance-tlb - исходящий трафик распределяется в соответствии с текущей нагрузкой по трафику (каламбур =) на интерфейсах;
- 6 или balance-alb - включает в себя balance-tlb, плюс балансировку на приём (rlb) и не требует применения специальных коммутаторов (балансировка на приём достигается на уровне протокола ARP, перехватом ARP ответов локальной системы и перезаписью физического адреса на адрес одного из сетевых интерфейсов, в зависимости от загрузки).

Пример конфигурации одолжил с [wiki.debian.org](https://wiki.debian.org/Bonding):  
```
auto bond0
iface bond0 inet static
    address 10.10.10.100
    netmask 255.255.255.0
    network 10.10.10.0
    gateway 10.10.10.1
    bond-slaves eth0 eth1
    bond-mode 4
    bond-miimon 100
    bond-downdelay 200
    bond-updelay 200
```

5. Сколько IP адресов в сети с маской /29?  
Ответ: 6  
Сколько /29 подсетей можно получить из сети с маской /24?  
Ответ: 32  
Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.  
Ответ:  
10.10.10.0/29  
10.10.10.8/29  
10.10.10.16/29  

6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

100.64.0.0/10 - Данная подсеть рекомендована согласно RFC 6598 для использования в качестве адресов для CGN (Carrier-Grade NAT)  
```
vagrant@vagrant:~$ ipcalc 100.127.255.254/26
Address:   100.127.255.254      01100100.01111111.11111111.11 111110
Netmask:   255.255.255.192 = 26 11111111.11111111.11111111.11 000000
Wildcard:  0.0.0.63             00000000.00000000.00000000.00 111111
=>
Network:   100.127.255.192/26   01100100.01111111.11111111.11 000000
HostMin:   100.127.255.193      01100100.01111111.11111111.11 000001
HostMax:   100.127.255.254      01100100.01111111.11111111.11 111110
Broadcast: 100.127.255.255      01100100.01111111.11111111.11 111111
Hosts/Net: 62                    Class A
```

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

Windows:  
- powershell:  
Get-NetNeighbor - выведет информацию обо всех ARP-записях  
Remove-NetNeighbor - удалит все ARP-записи  
- cmd:  
`arp -a` - выведет информацию обо всех ARP-записях  
`arp -d *` - удалит все ARP-записи

Linux:  
`arp -a` - выведет информацию обо всех ARP-записях  
`arp -d -a` - удалит все ARP-записи  
`ip neigh` - выведет информацию обо всех ARP-записях  
`ip neigh flush all` - удалит все ARP-записи

 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

 8*. Установите эмулятор EVE-ng.
 
 Инструкция по установке - https://github.com/svmyasnikov/eve-ng

 Выполните задания на lldp, vlan, bonding в эмуляторе EVE-ng. 