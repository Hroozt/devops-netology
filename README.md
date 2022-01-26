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
  GNU nano 4.8                                                                                                     script2.py
#!/usr/bin/env python3
import os
import socket
import sys
from time import sleep
fr=1
n=1
tlist=['drive.google.com', 'mail.google.com', 'google.com']

while n!=0:
    f=socket.gethostbyname(tlist[0])
    s=socket.gethostbyname(tlist[1])
    t=socket.gethostbyname(tlist[2])
    sleep(fr)
    print("\033c")
    cf=socket.gethostbyname(tlist[0])
    cs=socket.gethostbyname(tlist[1])
    ct=socket.gethostbyname(tlist[2])
    if (f == cf and s == cs and t == ct):
        print('URL:', tlist[0], 'IPv4:', f,'\t', 'URL:', tlist[1], 'IPv4:', s, '\t', 'URL:', tlist[2], 'IPv4:', t, '\t')
        sleep(fr)
    elif (f!=cf):
        print('ERROR:', tlist[0], 'IPv4 mismatch:', f, '->', cf, '\t', 'URL:', tlist[1], 'IPv4:', s, '\t', 'URL:', tlist[2], 'IPv4:', t, '\t')
        break
    elif (s!=cs):
        print('URL:', tlist[0], 'IPv4:', f,'\t', 'ERROR:', tlist[1], 'IPv4 mismatch:', s, '->', cs,  '\t', 'URL:', tlist[2], 'IPv4:', t, '\t')
        break
    elif (t!=ct):
        print('URL:', tlist[0], 'IPv4:', f,'\t', 'URL:', tlist[1], 'IPv4:', s, '\t', 'ERROR:', tlist[2], 'IPv4 mismatch:', t, '->', ct, '\t')
        break

```

### Вывод скрипта при запуске при тестировании:
работа скрипта
```
URL: drive.google.com IPv4: 173.194.73.194   URL: mail.google.com IPv4: 64.233.165.83     URL: google.com IPv4: 74.125.205.113
```
при изменении одного из адресов скрипт прерываеся
```
URL: drive.google.com IPv4: 173.194.73.194       URL: mail.google.com IPv4: 64.233.165.83        ERROR: google.com IPv4 mismatch: 74.125.205.101 -> 74.125.205.113
root@netology:/git#
```


