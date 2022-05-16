# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

```commandline
mysql> status
--------------
mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)

```

```commandline
mysql> show tables;
+----------------+
| Tables_in_test |
+----------------+
| orders         |
+----------------+
1 row in set (0.00 sec)


mysql> select * from orders where price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)

```
## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

```commandline
mysql> CREATE USER test
    -> IDENTIFIED WITH mysql_native_password BY 'test-pass'
    -> REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3
    -> ATTRIBUTE '{"lastname":"Pretty","firstname":"James"}'
    -> ;
Query OK, 0 rows affected (0.02 sec)

```

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

```commandline
mysql> GRANT SELECT ON test.* TO test
    -> ;
Query OK, 0 rows affected (0.01 sec)

```

Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

```commandline

mysql> select * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES where user='test';
+------+------+----------------------------------------------+
| USER | HOST | ATTRIBUTE                                    |
+------+------+----------------------------------------------+
| test | %    | {"lastname": "Pretty", "firstname": "James"} |
+------+------+----------------------------------------------+
1 row in set (0.00 sec)

```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.
```commandline
mysql> use test;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SET profiling = 1
    -> ;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SHOW PROFILES;
+----------+------------+-------------------+
| Query_ID | Duration   | Query             |
+----------+------------+-------------------+
|        1 | 0.00037350 | SELECT DATABASE() |
|        2 | 0.00172050 | show databases    |
|        3 | 0.00339425 | show tables       |
|        4 | 0.00034825 | SET profiling = 1 |
+----------+------------+-------------------+
4 rows in set, 1 warning (0.00 sec)


```

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

```commandline

mysql> select engine from information_schema.TABLES where table_name='orders';
+--------+
| ENGINE |
+--------+
| InnoDB |
+--------+
1 row in set (0.00 sec)

```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`

```commandline
mysql> ALTER TABLE orders Engine=MyIsam;
Query OK, 5 rows affected (0.09 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILE;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000131 |
| Executing hook on transaction  | 0.000017 |
| starting                       | 0.000038 |
| checking permissions           | 0.000016 |
| checking permissions           | 0.000012 |
| init                           | 0.000026 |
| Opening tables                 | 0.000778 |
| setup                          | 0.000250 |
| creating table                 | 0.002641 |
| waiting for handler commit     | 0.000042 |
| waiting for handler commit     | 0.005418 |
| After create                   | 0.001287 |
| System lock                    | 0.000042 |
| copy to tmp table              | 0.000287 |
| waiting for handler commit     | 0.000022 |
| waiting for handler commit     | 0.000035 |
| waiting for handler commit     | 0.000099 |
| rename result table            | 0.000296 |
| waiting for handler commit     | 0.028022 |
| waiting for handler commit     | 0.000051 |
| waiting for handler commit     | 0.009967 |
| waiting for handler commit     | 0.000043 |
| waiting for handler commit     | 0.020203 |
| waiting for handler commit     | 0.000045 |
| waiting for handler commit     | 0.007439 |
| end                            | 0.014393 |
| query end                      | 0.006637 |
| closing tables                 | 0.000029 |
| waiting for handler commit     | 0.000063 |
| freeing items                  | 0.000055 |
| cleaning up                    | 0.000037 |
+--------------------------------+----------+
31 rows in set, 1 warning (0.00 sec)

```
- на `InnoDB`
```commandline
mysql> ALTER TABLE orders Engine=InnoDB;
Query OK, 5 rows affected (0.11 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILE;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000137 |
| Executing hook on transaction  | 0.000020 |
| starting                       | 0.000042 |
| checking permissions           | 0.000018 |
| checking permissions           | 0.000014 |
| init                           | 0.000029 |
| Opening tables                 | 0.000496 |
| setup                          | 0.000117 |
| creating table                 | 0.000177 |
| After create                   | 0.040937 |
| System lock                    | 0.000060 |
| copy to tmp table              | 0.000415 |
| rename result table            | 0.002493 |
| waiting for handler commit     | 0.000045 |
| waiting for handler commit     | 0.013660 |
| waiting for handler commit     | 0.000047 |
| waiting for handler commit     | 0.028217 |
| waiting for handler commit     | 0.000044 |
| waiting for handler commit     | 0.015896 |
| waiting for handler commit     | 0.000049 |
| waiting for handler commit     | 0.008090 |
| end                            | 0.001149 |
| query end                      | 0.005086 |
| closing tables                 | 0.000033 |
| waiting for handler commit     | 0.000068 |
| freeing items                  | 0.000064 |
| cleaning up                    | 0.000042 |
+--------------------------------+----------+
27 rows in set, 1 warning (0.00 sec)


```

Итого 

```commandline
mysql> SHOW PROFILES;
+----------+------------+------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                  |
+----------+------------+------------------------------------------------------------------------+
...
                                      |
|       19 | 0.09841800 | ALTER TABLE orders Engine=MyIsam                                       |
|       20 | 0.11744000 | ALTER TABLE orders Engine=InnoDB                                       |
+----------+------------+------------------------------------------------------------------------+
15 rows in set, 1 warning (0.00 sec)

mysql>

```
## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

```commandline
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here


#Измените его согласно ТЗ (движок InnoDB):

#- Скорость IO важнее сохранности данных
innodb_flush_log_at_trx_commit  = 2

#- Нужна компрессия таблиц для экономии места на диске
innodb_file_per_table = 1
innodb_file_format = Barracuda

#- Размер буффера с незакомиченными транзакциями 1 Мб
innodb_log_buffer_size = 1M

#- Буффер кеширования 30% от ОЗУ
innodb_buffer_pool_size = 1200M

#- Размер файла логов операций 100 Мб
innodb_log_file_size = 100M

!includedir /etc/mysql/conf.d/

```