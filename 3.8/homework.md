# 3.8. Компьютерные сети, лекция 3

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```

Ответ поместил в [route-views.md](./route-views.md) ввиду большого листинга.

2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

```
vagrant@vagrant:~$ sudo ip link add dummy0 type dummy
vagrant@vagrant:~$ sudo ip link set dummy0 address 00:E0:4C:69:00:05
vagrant@vagrant:~$ sudo ip addr add 10.0.2.115/24 dev dummy0
vagrant@vagrant:~$ sudo ip link set up dummy0
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
       valid_lft 86054sec preferred_lft 86054sec
    inet6 fe80::a00:27ff:feb1:285d/64 scope link
       valid_lft forever preferred_lft forever
4: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 00:e0:4c:69:00:05 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.115/24 scope global dummy0
       valid_lft forever preferred_lft forever
    inet6 fe80::2e0:4cff:fe69:5/64 scope link
       valid_lft forever preferred_lft forever
```
```
vagrant@vagrant:~$ ip r
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
vagrant@vagrant:~$ sudo ip r add 192.168.10.0/24 dev eth0
vagrant@vagrant:~$ sudo ip r add 192.168.250.0/24 dev dummy0
vagrant@vagrant:~$ ip r
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.0/24 dev dummy0 proto kernel scope link src 10.0.2.115
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
192.168.10.0/24 dev eth0 scope link
192.168.250.0/24 dev dummy0 scope link
```

3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

Ответ: на ВМ слушаются 53/TCP службой разрешения сетевых имён и 22/TCP (также v6) демоном сервера SSH.
```
vagrant@vagrant:~$ sudo netstat -ntlp | egrep '(Proto|LISTEN)'
Proto Recv-Q Send-Q Local Address     Foreign Address     State       PID/Program name
tcp        0      0 127.0.0.53:53     0.0.0.0:*           LISTEN      618/systemd-resolve
tcp        0      0 0.0.0.0:22        0.0.0.0:*           LISTEN      681/sshd: /usr/sbin
tcp6       0      0 :::22             :::*                LISTEN      681/sshd: /usr/sbin
```

4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

Ответ: на ВМ слушаются 53/UDP службой разрешения сетевых имён. А также 68/UDP службой systemd-network для корректной работы клиента DHCP.
```
vagrant@vagrant:~$ sudo netstat -nulp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address      Foreign Address    State       PID/Program name
udp        0      0 127.0.0.53:53      0.0.0.0:*                      618/systemd-resolve
udp        0      0 10.0.2.15:68       0.0.0.0:*                      616/systemd-network
```

5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.

Ответ: [Network diagram](./3.8.5.drawio)

 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

6*. Установите Nginx, настройте в режиме балансировщика TCP или UDP.

7*. Установите bird2, настройте динамический протокол маршрутизации RIP.

8*. Установите Netbox, создайте несколько IP префиксов, используя curl проверьте работу API.