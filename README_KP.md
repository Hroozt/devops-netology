# Курсовая работа по итогам модуля "DevOps и системное администрирование"
## Задание

1. Создайте виртуальную машину Linux. 
   1. Установлена чистая ubuntu 20.04 из образов vagrant
 
2. Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты. 
   1. ufw был предустановлен. Сделано apt update \ apt upgrade 
   2. Виртуальная машина имеет 2 сетевых карты. eth0 работает в режиме NAT! eth1 в режиме bridge! loopback без изменений :) на сетевую eth1 будут проброшены внешние порты, для удлаенного подключения и публикации сайта. 
   3. Разрешены подлкючения на 22 и 443 порт через публичный интерфейс. разрешен SSH и любой трафик на LO

```cmdline
vagrant@netology:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere
80/tcp                     ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)
443/tcp (v6)               ALLOW       Anywhere (v6)
80/tcp (v6)                ALLOW       Anywhere (v6)
```
3. Установите hashicorp vault ([инструкция по ссылке](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started#install-vault)). 
   1. Установлено Hashicorp Vault.
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
4. Cоздайте центр сертификации по инструкции ([ссылка](https://learn.hashicorp.com/tutorials/vault/pki-engine?in=vault/secrets-management)) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).

   1. Доустанавливаем пакет jq. 

   2. Далее идем не по инструкции. так как там dev режим
   
   3. Запускаем службу vault ```systemctl start vault```
   
   4. устанавливаем переменную ```export VAULT_ADDR='https://127.0.0.1:8200'```
   
   5. перегенерируем сертификаты для доступа к ваулту на локальный IP (дефолтный видимо не содержит никаких имен узлов) 
   ```openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt  -config req.conf```
   
   6. онфиг генерации
   `[req]
   x509_extensions = v3_req
   prompt = no
   [req_distinguished_name]
   C = RU
   ST = N
   L = NSK
   O = NetologyDevOps
   OU = IT
   CN = Vault
   [v3_req]
   keyUsage = keyEncipherment, dataEncipherment
   extendedKeyUsage = serverAuth
   subjectAltName = @alt_names
   [alt_names]
   DNS.1 = localhost
   DNS.2 = hroozt.xyz
   IP.1 = 127.0.0.1`
   
   7. добавляем в доверенные сертификат (так как он самоподписанный) ъ 
   
   8. копируем сертификат командой вида: ```sudo cp tls.crt /usr/local/share/ca-certificates/``
   
   9. обновления общесистемного списка: ```sudo update-ca-certificates```
   
   10. Инициализируем Vault - получаем ключи распечатки. Сохраняем их!
   
   11. Теперь генерируем корневой, промежуточный и публичный ключи для настройк Nginx

Генерируем корневой сертификат
```
vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki
vault write -field=certificate pki/root/generate/internal common_name="hroozt.xyz" ttl=87600h > CA_cert.crt
vault write pki/config/urls issuing_certificates="$VAULT_ADDR/v1/pki/ca" crl_distribution_points="$VAULT_ADDR/v1/pki/crl
```
Генерируем промежуточный
```cmdline
vault secrets enable -path=pki_int pki
vault secrets tune -max-lease-ttl=43800h pki_int
vault write -format=json pki_int/intermediate/generate/internal common_name="Hroozt.xyz Intermediate Authority" | jq -r '.data.csr' > pki_intermediate.csr
vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr format=pem_bundle ttl="43800h" | jq -r '.data.certificate' > intermediate.cert.pem
```
Роль
```cmdline
vault write pki_int/roles/example-dot-com allowed_domains="hroozt.xyz" allow_subdomains=true allow_bare_domains=true max_ttl="720h"
```
Сам сертификат
```cmdline
vault write -format=json pki_int/issue/example-dot-com common_name="hroozt.xyz" ttl="720h" > hroozt.xyz.json
```
Разбираем на цепочку сертификатов (.crt) и ключ (.key)
```commandline
cat hroozt.xyz.json | jq -r '.data.certificate' > hroozt.xyz.crt
cat hroozt.xyz.json | jq -r '.data.ca_chain[]' >> hroozt.xyz.crt
cat hroozt.xyz.json | jq -r '.data.private_key' > hroozt.xyz.key
```
Получаем файлики
```commandline
ls -l
total 16
-rw-r--r-- 1 root root    0 Dec 26 17:14 CA_cert.crt
-rw-r--r-- 1 root root 2542 Dec 26 17:44 hroozt.xyz.crt
-rw-r--r-- 1 root root 6027 Dec 26 17:36 hroozt.xyz.json
-rw-r--r-- 1 root root 1675 Dec 26 17:44 hroozt.xyz.key
```

5. Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе. 
   1. CA_cert.crt - скопирован на хост (Windows) и импортирован в доверенные центры
    
   ![image](https://user-images.githubusercontent.com/92970717/147416181-a1e68c0a-78ac-4985-a0ad-92463c7b5400.png)

6. Установите nginx.
```commandline
root@netology:/etc/nginx/sites-enabled# service nginx start
root@netology:/etc/nginx/sites-enabled# service nginx status
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2021-12-26 17:59:55 UTC; 1s ago
       Docs: man:nginx(8)
    Process: 1849 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 1860 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 1861 (nginx)
      Tasks: 3 (limit: 2320)
     Memory: 3.6M
     CGroup: /system.slice/nginx.service
             ├─1861 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
             ├─1862 nginx: worker process
             └─1863 nginx: worker process

Dec 26 17:59:55 netology systemd[1]: Starting A high performance web server and a reverse proxy server...
Dec 26 17:59:55 netology systemd[1]: Started A high performance web server and a reverse proxy server.
root@netology:/etc/nginx/sites-enabled#
```
7. По инструкции ([ссылка](https://nginx.org/en/docs/http/configuring_https_servers.html)) настройте nginx на https, используя ранее подготовленный сертификат:
  - можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;
  - можно использовать и другой html файл, сделанный вами; 

    1. конфигурация сайта:
```commandline
server {
listen 443 ssl;
listen [::]:443 ssl;
root /var/www/html;
# Add index.php to the list if you are using PHP
index index.html index.htm index.nginx-debian.html;
server_name www.hroozt.xyz;
location / {
                try_files $uri $uri/ =404;
        }
    ssl_certificate    /etc/nginx/CA/hroozt.xyz.crt;
    ssl_certificate_key  /etc/nginx/CA/hroozt.xyz.key;
    ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers         HIGH:!aNULL:!MD5;

}
```
8. Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.

![image](https://user-images.githubusercontent.com/92970717/147416457-2f34c2c2-5cea-4f93-b096-0ed2ad7511fa.png)

9. Создайте скрипт, который будет генерировать новый сертификат в vault:
  - генерируем новый сертификат так, чтобы не переписывать конфиг nginx;
  - перезапускаем nginx для применения нового сертификата.
>Скрипт выполняет все действия выше. токен и ключи берутся из файлика key
```commandline

#!/usr/bin/env bash
#Экспорт переменной
export VAULT_ADDR=https://127.0.0.1:8200
systemctl start vault
#распечатка ваулта
vault operator unseal $(sed -n 1p key)
vault operator unseal $(sed -n 2p key)
vault operator unseal $(sed -n 3p key)
vault login $(sed -n 6p key)
#генерация ключа
vault write -format=json pki_int/issue/example-dot-com common_name="hroozt.xyz" ttl="1h" > /etc/nginx/CA/tmp.json
#парсим файлик, делаем ключи
cat /etc/nginx/CA/tmp.json | jq -r '.data.certificate' > /etc/nginx/CA/hroozt.xyz.crt
cat /etc/nginx/CA/tmp.json | jq -r '.data.ca_chain[]' >> /etc/nginx/CA/hroozt.xyz.crt
cat /etc/nginx/CA/tmp.json | jq -r '.data.private_key' > /etc/nginx/CA/hroozt.xyz.key
systemctl restart nginx

```


10. Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.

```crontab -e -u root```

```5 * * * * /etc/nginx/CA/renew.sh```

Запускает скрипт каждую 5 минуту. Можно проверить на сайте https://hroozt.xyz

