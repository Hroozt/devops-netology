# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Error. int + str не складываются |
| Как получить для переменной `c` значение 12?  | c=str(a)+b  |
| Как получить для переменной `c` значение 3?  | c=a+int(b)  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python

#!/usr/bin/env python3

import os

git_path = "/git"
bash_command = ["cd " + git_path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(git_path, "/", prepare_result, sep='')
#        break - прерывает скрипт на 1 совпадении

```

### Вывод скрипта при запуске при тестировании:
```
root@netology:/git# git status
On branch master
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   file1
        new file:   file2

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   file1
        modified:   file2
        modified:   script.py

root@netology:/git# ./script.py
/git/file1
/git/file2
/git/script.py

```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python

#!/usr/bin/env python3

import os
from sys import argv
n=argv

#проверка на передачу аргумента при запуске. если нет - запрос на ввод аргумента
if len(n)== 1:
    print("Input path to repo")
    tmp=input()
else:
    tmp=argv[1]

bash_command = ["cd " + tmp, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False

print("Modified files:")
for result in result_os.split('\n'):
    if result.find('modified') != -1:

```

### Вывод скрипта при запуске при тестировании:
```
root@netology:/git# ./script.py
Input path to repo
/git
Modified files:
/git/file1
/git/file2
/git/script.py

root@netology:/git# ./script.py /git
Modified files:
/git/file1
/git/file2
/git/script.py

```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
 #!/usr/bin/env python3
# Скрипт проверяет изменение IP адресов переданныйх на вход
import socket
from time import sleep
import os
import json
import yaml

tlist = {'drive.google.com': '0.0.0.0', 'mail.google.com': '0.0.0.0', 'google.com': '0.0.0.0'}
n = 1


# Функция заполнения словаря Актуальными IP адресами
def fill_tlist(x):
    for node in x:
        ipaddres = socket.gethostbyname(node)
        x[node] = ipaddres
    return x


# запись в формате json \ yaml
def fill_json_yaml(y):
    with open('hosts.json', 'w') as jtmp:
        jtmp.write(str(json.dumps(y)))
    with open('hosts.yaml', 'w') as ytmp:
        ytmp.write(yaml.dump(y))
    return


# заполним словарь и запишем YAML\JSON чтобы был актуальный спикок всегда
fill_json_yaml(fill_tlist(tlist))


# цикл проверки изменения адреса. цикл прерывается при изменениях и записывает последние актуальные адреса в JSON \ YAML
while n != 0:
    tmp = fill_tlist(tlist)
    sleep(1)
    os.system('cls')
    for host in tmp:
        ipaddress = socket.gethostbyname(host)
        if ipaddress != tmp[host]:
            print(' [ERROR] ' + str(host) + ' IP mistmatch: ' + tmp[host] + ' ---> ' + ipaddress)
            tmp[host] = ipaddress
            fill_json_yaml(tmp)
            n = 0
        else:
            print(str(host) + ' ' + ipaddress + ' OK ')

```

### Вывод скрипта при запуске при тестировании:
работа скрипта
```
drive.google.com 173.194.73.194 OK
mail.google.com 64.233.165.17 OK
google.com 64.233.161.100 OK
```
при изменении одного из адресов скрипт прерываеся
```
drive.google.com 173.194.73.194 OK
 [ERROR] mail.google.com IP mistmatch: 64.233.165.83 ---> 64.233.165.17
google.com 64.233.161.139 OK

```


