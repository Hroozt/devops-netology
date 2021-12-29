#!/usr/bin/env bash
#Экспорт переменной
export VAULT_ADDR=http://127.0.0.1:8200
systemctl vault start
#распечатка ваулта
vault operator unseal d4vJ05kuzJlOobmgImYi8p98XBcAHkt9a4khYtd5HAeg
vault operator unseal 3P//CQUYqNtprpd7AUkHy29WBnhEZVq+xuPkm3gAADfI
vault operator unseal XaxHVvrwyjLd2TXwmk8bX6H+F5HwhDwX3s5+g9qXQSCT
vault login s.eSoP4f5HZFpiuDU1UoDMFHZg
#генерация ключа
vault write -format=json pki_int/issue/example-dot-com common_name="hroozt.xyz" ttl="1h" > /etc/nginx/CA/tmp.json
#парсим файлик, делаем ключи
cat /etc/nginx/CA/tmp.json | jq -r '.data.certificate' > /etc/nginx/CA/hroozt.xyz.crt
cat /etc/nginx/CA/tmp.json | jq -r '.data.ca_chain[]' >> /etc/nginx/CA/hroozt.xyz.crt
cat /etc/nginx/CA/tmp.json | jq -r '.data.private_key' > /etc/nginx/CA/hroozt.xyz.key
systemctl vault stop
systemctl nginx restart




