# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
```commandline
  \l[+]   [PATTERN]      list databases
```
- подключения к БД
```commandline
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo} connect to new database (currently "postgres")
```
- вывода списка таблиц
```commandline
   \dt[S+] [PATTERN]      list tables
```
- вывода описания содержимого таблиц
```commandline
 \d[S+]  NAME           describe table, view, sequence, or index
```
- выхода из psql
```commandline
\q
```

## Задача 2

Используя `psql` создайте БД `test_database`.
```commandline
postgres=# CREATE DATABASE test_db;
CREATE DATABASE

```
Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
```commandline
[hroozt@localhost hw64]$ ls
docker-compose  test_dump.sql  volume
[hroozt@localhost hw64]$ cp test_dump.sql ./volume/test_dump.sql
[hroozt@localhost hw64]$ sudo docker exec -it hw64-db-1 /bin/bash               [sudo] пароль для hroozt:
root@f755625d4355:/# ls
bin   docker-entrypoint-initdb.d  lib    mnt   root  srv  usr
boot  etc                         lib64  opt   run   sys  var
dev   home                        media  proc  sbin  tmp
root@f755625d4355:/# su - postgres
postgres@f755625d4355:~$ ls
data  test_dump.sql
postgres@f755625d4355:~$ psql test_db < test_dump.sql

```
Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию для сбора статистики по таблице.

```commandline

postgres=# \c test_db
You are now connected to database "test_db" as user "postgres".
test_db=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

test_db=# ANALYZE orders;
ANALYZE
test_db=# ^C
test_db=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE

```
Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.
```commandline

test_db=# SELECT attname,avg_width FROM pg_stats WHERE tablename = 'orders';
 attname | avg_width
---------+-----------
 id      |         4
 title   |        16
 price   |         4
(3 rows)

```
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.
```commandline
BEGIN;
CREATE TABLE orders_h () INHERITS (orders);
CREATE TABLE orders_l () INHERITS (orders);
INSERT INTO orders_h SELECT * FROM orders_hi;
INSERT INTO orders_l SELECT * FROM orders_low;
DELETE FROM orders;
COMMIT;
```
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
Да, если задать условия и прописать 

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.
```commandline
pg_dump -f /var/tmp/dump.sql -h db -p 5432 -U postgres test_db
```
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

_можно в файле дампа дописать признак UNIQUE_
```
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) UNIQUE,
    price integer DEFAULT 0
);
```
---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---