# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"
---

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
>Исключение человеческого фактора, путем автоматизации всего, что можно автоматизировать.
>Маштабируемость и скорость развертки сервисов
>Прогнозируемость и повторяемость результата
- Какой из принципов IaaC является основополагающим?
> Идентичный результат предыдущих и последующих исполнений описанной конфигурации\функции\кода (Идемпотентность)

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
>Использует текущую SSH инфраструктуру, что упрощает работу и не требует развертывания дополнительной инфраструктуры публичных ключей.
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
>Мое мнение что надежность у PUSH и PULL одинаковая, отличе лишь в инициаторе, при нарушении канала связи оба метода буду неработоспособными.

## Задача 3

Установить на личный компьютер:

- VirtualBox
```
[root@localhost hroozt]# virtualbox -h
Oracle VM VirtualBox VM Selector v6.1.32
(C) 2005-2022 Oracle Corporation
All rights reserved.

No special options.
```
- Vagrant
```
[root@localhost hroozt]# vagrant --version
Vagrant 2.2.19
```
- Ansible
```
[root@localhost hroozt]# ansible --version
ansible 2.9.27
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.6/site-packages/ansible
  executable location = /bin/ansible
  python version = 3.6.8 (default, Jan 19 2022, 23:28:49) [GCC 8.5.0 20210514 (Red Hat 8.5.0-7)]
```

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
[root@localhost vagrantvm]# ssh vagrant
ssh: Could not resolve hostname vagrant: Name or service not known
[root@localhost vagrantvm]# vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sat 12 Feb 2022 07:03:25 PM UTC

  System load:  0.75               Users logged in:          0
  Usage of /:   13.4% of 30.88GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 24%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.56.11
  Processes:    111


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Sat Feb 12 19:02:09 2022 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ 
```
