1. Установлена чистая ubuntu 20.04 из образов vagrant
2. ufw был предустановлен. Сделано apt update \ apt upgrade
3. Виртуальная машина имеет 2 сетевых карты. eth0 работает в режиме NAT! eth1 в режиме bridge! loopback без изменений :) на сетевую eth1 будут проброшены внешние порты, для удлаенного подключения и публикации сайта.
4. Разрешены подлкючения на 22 и 443 порт через публичный интерфейс.
```cmdline
root@netology:/home/vagrant# ufw allow in on eth1 to 172.22.0.50 proto tcp port 22
Rule added
root@netology:/home/vagrant# ufw allow in on eth1 to 172.22.0.50 proto tcp port 443
Rule added
root@netology:/home/vagrant#
```
