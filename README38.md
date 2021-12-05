# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP

```commandline
route-views>show ip route 94.180.120.128
Routing entry for 94.180.96.0/19
  Known via "bgp 6447", distance 20, metric 0
  Tag 6939, type external
  Last update from 64.71.137.241 7w0d ago
  Routing Descriptor Blocks:
  * 64.71.137.241, from 64.71.137.241, 7w0d ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 6939
      MPLS label: none
```

```commandline
route-views>show bgp 94.180.120.128
BGP routing table entry for 94.180.96.0/19, version 65712536
Paths: (24 available, best #23, table default)
  Not advertised to any peer
  Refresh Epoch 3
  3303 9002 9049 43478
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external
      Community: 3303:1004 3303:1007 3303:1030 3303:3067 9002:64667
      path 7FE00FECCCA8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 9002 9049 43478
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE00B0E7238 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7660 2516 1299 9049 43478
    203.181.248.168 from 203.181.248.168 (203.181.248.168)
      Origin IGP, localpref 100, valid, external
      Community: 2516:1030 7660:9003
      path 7FE124345498 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3267 9049 43478
    194.85.40.15 from 194.85.40.15 (185.141.126.1)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE0C08F39A8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  57866 9002 9049 43478
    37.139.139.17 from 37.139.139.17 (37.139.139.17)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 9002:0 9002:64667
      path 7FE140D6DCC8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7018 1299 9049 43478
    12.0.1.63 from 12.0.1.63 (12.0.1.63)
      Origin IGP, localpref 100, valid, external
      Community: 7018:5000 7018:37232
      path 7FE04E8B74B0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3333 9002 9049 43478
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin IGP, localpref 100, valid, external
      path 7FE12990FC58 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  49788 1299 9049 43478
    91.218.184.60 from 91.218.184.60 (91.218.184.60)
      Origin IGP, localpref 100, valid, external
      Community: 1299:30000
      Extended Community: 0x43:100:1
      path 7FE10AB0D418 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20912 3257 1299 9049 43478
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin IGP, localpref 100, valid, external
      Community: 3257:8101 3257:30055 3257:50001 3257:53900 3257:53902 20912:65004
      path 7FE0A30823D8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  8283 1299 9049 43478
    94.142.247.3 from 94.142.247.3 (94.142.247.3)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 1299:30000 8283:1 8283:101
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x18
        value 0000 205B 0000 0000 0000 0001 0000 205B
              0000 0005 0000 0001
      path 7FE1194100D0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3356 9002 9002 9002 9002 9002 9049 43478
    4.68.4.46 from 4.68.4.46 (4.69.184.201)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067
      path 7FE130313860 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1221 4637 9002 9049 43478
    203.62.252.83 from 203.62.252.83 (203.62.252.83)
      Origin IGP, localpref 100, valid, external
      path 7FE174418510 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  2497 1299 9049 43478
    202.232.0.2 from 202.232.0.2 (58.138.96.254)
      Origin IGP, localpref 100, valid, external
      path 7FE050660AC0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  852 1299 9049 43478
    154.11.12.212 from 154.11.12.212 (96.1.209.43)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE1692A3B90 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20130 6939 9049 43478
    140.192.8.16 from 140.192.8.16 (140.192.8.16)
      Origin IGP, localpref 100, valid, external
      path 7FE1699E31B0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  701 1299 9049 43478
    137.39.3.55 from 137.39.3.55 (137.39.3.55)
      Origin IGP, localpref 100, valid, external
      path 7FE00668F790 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3257 1299 9049 43478
    89.149.178.10 from 89.149.178.10 (213.200.83.26)
      Origin IGP, metric 10, localpref 100, valid, external
      Community: 3257:8794 3257:30052 3257:50001 3257:54900 3257:54901
      path 7FE1676F45E8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 9002 9002 9002 9002 9002 9049 43478
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:2 3356:22 3356:100 3356:123 3356:503 3356:903 3356:2067 3549:2581 3549:30840
      path 7FE025AFD5C0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  53767 174 174 1299 9049 43478
    162.251.163.2 from 162.251.163.2 (162.251.162.3)
      Origin IGP, localpref 100, valid, external
      Community: 174:21000 174:22013 53767:5000
      path 7FE1170E6410 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  101 174 1299 9049 43478
    209.124.176.223 from 209.124.176.223 (209.124.176.223)
      Origin IGP, localpref 100, valid, external
      Community: 101:20100 101:20110 101:22100 174:21000 174:22013
      Extended Community: RT:101:22100
      path 7FE0C2DA3050 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3561 3910 3356 9002 9002 9002 9002 9002 9049 43478
    206.24.210.80 from 206.24.210.80 (206.24.210.80)
      Origin IGP, localpref 100, valid, external
      path 7FE04910D610 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1351 6939 9049 43478
    132.198.255.253 from 132.198.255.253 (132.198.255.253)
      Origin IGP, localpref 100, valid, external
      path 7FE0484C6B20 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  6939 9049 43478
    64.71.137.241 from 64.71.137.241 (216.218.252.164)
      Origin IGP, localpref 100, valid, external, best
      path 7FE0D83D8190 RPKI State not found
      rx pathid: 0, tx pathid: 0x0
  Refresh Epoch 1
  19214 174 1299 9049 43478
    208.74.64.40 from 208.74.64.40 (208.74.64.40)
      Origin IGP, localpref 100, valid, external
      Community: 174:21000 174:22013
      path 7FE09FF34778 RPKI State not found
      rx pathid: 0, tx pathid: 0
```

3. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
>Интерфейс создан `sudo modprobe -v dummy numdummies=2` и поднят.
```commandline
root@vagrant:/home/vagrant# ip -br a
lo               UNKNOWN        127.0.0.1/8 ::1/128
eth0             UP             10.0.2.15/24 fe80::a00:27ff:fe73:60cf/64
eth1             UP             172.17.8.73/24 fe80::a00:27ff:fef8:274c/64
dummy0           UNKNOWN        10.11.12.13/24 fe80::211:22ff:fe33:4455/64
dummy1           DOWN
root@vagrant:/home/vagrant# ping 10.11.12.13
PING 10.11.12.13 (10.11.12.13) 56(84) bytes of data.
64 bytes from 10.11.12.13: icmp_seq=1 ttl=64 time=0.023 ms
64 bytes from 10.11.12.13: icmp_seq=2 ttl=64 time=0.032 ms
64 bytes from 10.11.12.13: icmp_seq=3 ttl=64 time=0.030 ms

```
```commandline
root@vagrant:/home/vagrant# ip r                                                #смотрим маршруты по умолчанию
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
default via 172.17.8.1 dev eth1 proto dhcp src 172.17.8.73 metric 100
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
10.11.12.0/24 dev dummy0 proto kernel scope link src 10.11.12.13
172.17.8.0/24 dev eth1 proto kernel scope link src 172.17.8.73
172.17.8.1 dev eth1 proto dhcp scope link src 172.17.8.73 metric 100
root@vagrant:/home/vagrant# ip r add 8.8.8.0/24 via 10.11.12.13 dev dummy0      #добавляем маршрут заглушку для сети 8.8.8.0/24
root@vagrant:/home/vagrant# ip r                                                #смотрим маршруты после добавления
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
default via 172.17.8.1 dev eth1 proto dhcp src 172.17.8.73 metric 100
8.8.8.0/24 via 10.11.12.13 dev dummy0                                           # <-- вот наша "подлость"
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
10.11.12.0/24 dev dummy0 proto kernel scope link src 10.11.12.13
172.17.8.0/24 dev eth1 proto kernel scope link src 172.17.8.73
172.17.8.1 dev eth1 proto dhcp scope link src 172.17.8.73 metric 100
root@vagrant:/home/vagrant# ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
^C
--- 8.8.8.8 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2026ms                #И соответственно пинги на 8.8.8.8 идут в лес**

root@vagrant:/home/vagrant# ip r add 8.8.8.8/32 via 172.17.8.1 dev eth1         #Добавляем более приоритетный маршрут для 8.8.8.8 чтобы шло правильно, некое Искльюения получается**
root@vagrant:/home/vagrant# ip r
default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100
default via 172.17.8.1 dev eth1 proto dhcp src 172.17.8.73 metric 100
8.8.8.0/24 via 10.11.12.13 dev dummy0
8.8.8.8 via 172.17.8.1 dev eth1                                                 # <-- вот наше "Исключение"**
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100
10.11.12.0/24 dev dummy0 proto kernel scope link src 10.11.12.13
172.17.8.0/24 dev eth1 proto kernel scope link src 172.17.8.73
172.17.8.1 dev eth1 proto dhcp scope link src 172.17.8.73 metric 100
root@vagrant:/home/vagrant# ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=109 time=53.7 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=109 time=53.5 ms
^C
--- 8.8.8.8 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms                  #И соответственно пинги на 8.8.8.8 идут куда надо**
rtt min/avg/max/mdev = 53.482/53.575/53.669/0.093 ms

```
4. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.
>выдержка команды netstat на сервер для наглядности
```commandline
root@jupiter:/home/glos# netstat -a | grep LISTEN
tcp        0      0 *:ssh                   *:*                     LISTEN <-- слушает 22 порт для подключения по SSH
tcp        0      0 *:smtp                  *:*                     LISTEN <-- слушает 25 для получения потчы
tcp        0      0 *:https                 *:*                     LISTEN <-- слушает 443 для подключения на внутренний вЭбсервер (Апач)
tcp        0      0 *:zabbix-agent          *:*                     LISTEN 
tcp        0      0 *:3333                  *:*                     LISTEN
tcp        0      0 *:lotusnote             *:*                     LISTEN
...

```

6. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
```commandline
root@jupiter:/home/glos# netstat -n --udp --listen
Активные соединения с интернетом (only servers)
Proto Recv-Q Send-Q Local Address Foreign Address State
udp        0      0 0.0.0.0:68              0.0.0.0:*       <-- на данном хосте слушается например 68 порт, для DHCP
```
7. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 
> https://drive.google.com/file/d/151PI9TyeXas7DRbSW149Kh5UYywbqgc-/view?usp=sharing