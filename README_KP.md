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
5. Установлено Hashicorp Vault.
```cmdline
root@netology:/home/vagrant# vault
Usage: vault <command> [args]

Common commands:
    read        Read data and retrieves secrets
    write       Write data, configuration, and secrets
    delete      Delete secrets and configuration
    list        List data or secrets
    login       Authenticate locally
    agent       Start a Vault agent
    server      Start a Vault server
    status      Print seal and HA status
    unwrap      Unwrap a wrapped secret

Other commands:
    audit          Interact with audit devices
    auth           Interact with auth methods
    debug          Runs the debug command
    kv             Interact with Vault's Key-Value storage
    lease          Interact with leases
    monitor        Stream log messages from a Vault server
    namespace      Interact with namespaces
    operator       Perform operator-specific tasks
    path-help      Retrieve API help for paths
    plugin         Interact with Vault plugins and catalog
    policy         Interact with policies
    print          Prints runtime configurations
    secrets        Interact with secrets engines
    ssh            Initiate an SSH session
    token          Interact with tokens
root@netology:/home/vagrant#
```

========================================
Установите hashicorp vault (инструкция по ссылке).
Cоздайте центр сертификации по инструкции (ссылка) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).
Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.
Установите nginx.
По инструкции (ссылка) настройте nginx на https, используя ранее подготовленный сертификат:
можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;
можно использовать и другой html файл, сделанный вами;
Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.
Создайте скрипт, который будет генерировать новый сертификат в vault:
генерируем новый сертификат так, чтобы не переписывать конфиг nginx;
перезапускаем nginx для применения нового сертификата.
Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.
