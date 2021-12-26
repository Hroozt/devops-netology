# Курсовая работа по итогам модуля "DevOps и системное администрирование"
## Задание

1. Создайте виртуальную машину Linux.
> 
> Установлена чистая ubuntu 20.04 из образов vagrant
> 
2. Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.
> 
> ufw был предустановлен. Сделано apt update \ apt upgrade
> 
>Виртуальная машина имеет 2 сетевых карты. eth0 работает в режиме NAT! eth1 в режиме bridge! loopback без изменений :) на сетевую eth1 будут проброшены внешние порты, для удлаенного подключения и публикации сайта.
>
>Разрешены подлкючения на 22 и 443 порт через публичный интерфейс. разрешен SSH и любой трафик на LO
>
```cmdline
root@netology:/home/vagrant# ufw status
Status: active

To                         Action      From
--                         ------      ----
172.22.0.50 22/tcp on eth1 ALLOW       Anywhere
172.22.0.50 443/tcp on eth1 ALLOW       Anywhere
172.22.0.50 8200/tcp on eth1 ALLOW       Anywhere
22/tcp                     ALLOW       Anywhere
Anywhere on lo             ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)
Anywhere (v6) on lo        ALLOW       Anywhere (v6)

Anywhere                   ALLOW OUT   Anywhere on lo
Anywhere (v6)              ALLOW OUT   Anywhere (v6) on lo
```
3. Установите hashicorp vault ([инструкция по ссылке](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started#install-vault)).
>
>Установлено Hashicorp Vault.
>
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
> 
> Доустанавливаем пакет jq.
> 
> Далее идем по инструкции.
> 
>> 
>> Через vagrnat ssh подключаемся к VM. и запускаем vault в dev режиме:
>> 
```cmdline
WARNING! dev mode is enabled! In this mode, Vault runs entirely in-memory
and starts unsealed with a single unseal key. The root token is already
authenticated to the CLI, so you can immediately begin using Vault.

You may need to set the following environment variable:

    $ export VAULT_ADDR='http://127.0.0.1:8200'

The unseal key and root token are displayed below in case you want to
seal/unseal the Vault or re-authenticate.

Unseal Key: NzjwP1Uxh1x2JRZAzAsgz9vk7Sd7wDlcd+tXpOw5Q94=
Root Token: root

Development mode should NOT be used in production installations!
```
>>
>>Через ssh подключаемся в другой терминал и делаем выпуск сертификата
>>
>>Генерируем корневой сертификат
>>
```cmdline
root@netology:/home/vagrant# export VAULT_ADDR=http://127.0.0.1:8200
root@netology:/home/vagrant# export VAULT_TOKEN=root
root@netology:/home/vagrant# vault secrets enable pki
Success! Enabled the pki secrets engine at: pki/
root@netology:/home/vagrant# vault secrets tune -max-lease-ttl=87600h pki
Success! Tuned the secrets engine at: pki/
root@netology:/home/vagrant# vault write -field=certificate pki/root/generate/internal \
>      common_name="hroozt.xyz" \
>      ttl=87600h > CA_cert.crt
root@netology:/home/vagrant# vault write pki/config/urls \
>      issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
>      crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
Success! Data written to: pki/config/urls
```
>>Генерерируем промежуточный сертификат
>>
```cmdline
root@netology:/home/vagrant# vault secrets enable -path=pki_int pki
Success! Enabled the pki secrets engine at: pki_int/
root@netology:/home/vagrant# vault secrets tune -max-lease-ttl=43800h pki_int
Success! Tuned the secrets engine at: pki_int/
root@netology:/home/vagrant# vault write -format=json pki_int/intermediate/generate/internal \
>      common_name="Hroozt.xyz Intermediate Authority" \
>      | jq -r '.data.csr' > pki_intermediate.csr
root@netology:/home/vagrant# vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
>      format=pem_bundle ttl="43800h" \
>      | jq -r '.data.certificate' > intermediate.cert.pem
root@netology:/home/vagrant# vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
Success! Data written to: pki_int/intermediate/set-signed
```
>>Создаем роль
>>
```cmdline
root@netology:/home/vagrant# vault write pki_int/roles/example-dot-com \
>      allowed_domains="hroozt.xyz" \
>      allow_subdomains=true \
>      max_ttl="720h"
Success! Data written to: pki_int/roles/example-dot-com
```
>>генерируем сертификат в формате json
```cmdline
root@netology:/home/vagrant# vault write -format=json pki_int/issue/example-dot-com common_name="hroozt.xyz" ttl="720h" > hroozt.xyz.json
```
>>разбираем на цепочку сертификатов (.crt) и ключ (.key)
```commandline
root@netology:/home/vagrant# cat hroozt.xyz.json | jq -r '.data.certificate' > hroozt.xyz.crt
root@netology:/home/vagrant# cat hroozt.xyz.json | jq -r '.data.ca_chain[]' >> hroozt.xyz.crt
root@netology:/home/vagrant# cat hroozt.xyz.json | jq -r '.data.private_key' > hroozt.xyz.key
```
>>получаем файлики
```commandline
root@netology:/home/vagrant# ls -l
total 16
-rw-r--r-- 1 root root    0 Dec 26 17:14 CA_cert.crt
-rw-r--r-- 1 root root 2542 Dec 26 17:44 hroozt.xyz.crt
-rw-r--r-- 1 root root 6027 Dec 26 17:36 hroozt.xyz.json
-rw-r--r-- 1 root root 1675 Dec 26 17:44 hroozt.xyz.key
```

5. Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.
> CA_cert.crt - скопирован на хост (Windows) и импортирован в доверенные центры
> ![image](https://user-images.githubusercontent.com/92970717/147416181-a1e68c0a-78ac-4985-a0ad-92463c7b5400.png)

6. Установите nginx.
>
7. По инструкции ([ссылка](https://nginx.org/en/docs/http/configuring_https_servers.html)) настройте nginx на https, используя ранее подготовленный сертификат:
  - можно использовать стандартную стартовую страницу nginx для демонстрации работы сервера;
  - можно использовать и другой html файл, сделанный вами;
>
8. Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.
>
9. Создайте скрипт, который будет генерировать новый сертификат в vault:
  - генерируем новый сертификат так, чтобы не переписывать конфиг nginx;
  - перезапускаем nginx для применения нового сертификата.
>
10. Поместите скрипт в crontab, чтобы сертификат обновлялся какого-то числа каждого месяца в удобное для вас время.
>

