# Домашнее задание N09

1. На лекции мы познакомились с node_exporter . В демонстрации его исполняемый файл запускался в
background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться
под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter : поместите его в автозагрузку, предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на systemctl cat cron ), удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

```
[Unit]  
Description=Node Exporter  
  
[Service]  
EnvironmentFile=-/etc/sysconfig/node_exporter  
ExecStart=/opt/node_exporter/node_exporter $OPTIONS  
  
[Install]  
WantedBy=multi-user.target  
Результат: Запущенный Node exporter
```
2. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. Приведите несколько опций,
которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

```
CPU:
node_cpu_seconds_total
RAM:
node_memory_SwapFree_bytes
node_memory_MemAvailable_bytes
node_memory_MemFree_bytes
node_memory_MemTotal_bytes
диск:
node_disk_io_now
node_disk_io_time_seconds_total
node_disk_io_time_weighted_seconds_total
node_disk_read_bytes_total
node_disk_written_bytes_total
сеть:
node_network_speed_bytes
node_network_transmit_bytes_total
node_network_transmit_errs_total
node_network_receive_bytes_total
node_network_receive_errs_total
```

3. Установите в свою виртуальную машину Netdata . Воспользуйтесь готовыми пакетами для установки
(sudo apt install -y netdata) . После успешной установки:
в конфигурационном файле /etc/netdata/netdata.conf в секции [web]
замените значение с localhost на bind to = 0.0.0.0,
добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте vagrant reload :
config.vm.network "forwarded_port", guest: 19999, host: 19999  
После успешной перезагрузки в браузере на своем ПК (не в виртуальной машине) вы должны суметь зайти на localhost:19999
Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
![netdata](https://user-images.githubusercontent.com/92970717/143732026-f12b191d-1189-4c56-be45-4674a3aee6f9.png)


4. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании,
а на системе виртуализации?*

```
Можно.
```
![dmesg_virt](https://user-images.githubusercontent.com/92970717/143731899-9854e0cf-8f4b-4ea5-a018-7be54f0e4c1e.png)

5. Как настроен sysctl fs.nr_open на системе по-умолчанию? Узнайте, что означает
этот параметр. Какой другой существующий лимит не позволит достичь такого числа (ulimit --help) ?

```
fs.nr_open - максимальное количество открытых файлов в системе.
По умолчанию задано 1048576, это hard limit.
есть ещё soft limit для пользователей 1024 файла по умолчанию. - в это и упрется.
```

6. Запустите любой долгоживущий процесс (не ls , который отработает мгновенно, а, например, sleep 1h )
в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter .
Для простоты работайте в данном задании под root ( sudo -i ). Под обычным пользователем требуются дополнительные
опции (--map-root-user) и т.д.

Запускаем в отдельном неймспейсе процесс sleep 1
```
root@vagrant:/home/vagrant# ubshare -f --pid --mount-proc sleep 1h
```

![nsenter](https://user-images.githubusercontent.com/92970717/143731950-ac4841bc-812a-4c57-bcf4-4d465a3ab880.png)


Задача 7
Найдите информацию о том, что такое :(){ :|:& };: . Запустите эту команду в своей виртуальной машине
Vagrant с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). Некоторое время все будет "плохо",
после чего (минуты) – ОС должна стабилизироваться. Вызов dmesg расскажет, какой механизм помог автоматической
стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

:(){ :|:& };: - это форк-бомба. рекурсивное создание процессов. ограничения в cgroups на число процессов прервут процесс. 
