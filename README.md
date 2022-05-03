# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

_Образец взят с репо postgers на dockerhub
adminer - для собственного интереса пощупать_
```yaml
# Use postgres/example user/password credentials
version: '3.1'

services:

  db:
    image: postgres:12
    restart: always
    environment:
      POSTGRES_PASSWORD: 12345
    volumes:
      - /home/hroozt/hw62/docker62/dbsm:/var/lib/postgresql
      - /home/hroozt/hw62/docker62/backup:/backup

  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080
```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
```
postgres=# create database test_db;
CREATE DATABASE
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
```

_**Создать test-admin-user не получилоь (Видимо дефис запрещен), бвл создан test_admin_user**_
```
postgres-# create user test-admin-user;
ERROR:  syntax error at or near "-"
LINE 1: create user test-admin-user
                        ^
postgres=# create user test_admin_user;
CREATE ROLE
postgres=# \du
                                      List of roles
    Role name    |                         Attributes                         | Member of
-----------------+------------------------------------------------------------+-----------
 postgres        | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 test_admin_user |                                                            | {}


```

- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
```
create table "orders" (
id INT,
name char (50),
price int,
PRIMARY KEY (id)
)
```
```
CREATE TABLE "clients" (
  "id" integer NOT NULL PRIMARY KEY,
  "lastname" character(50) NOT NULL,
  "country" character(50) NOT NULL,
  "order" integer NOT NULL,
FOREIGN KEY ("order") REFERENCES "orders" ("id") ON DELETE SET NULL ON UPDATE RESTRICT
)

CREATE INDEX "clients_country" ON "clients" ("country");
```

- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db

```GRANT ALL PRIVILEGES ON DATABASE "test_db" TO test_admin_user;```

- создайте пользователя test-simple-user

```
CREATE ROLE test_simple_user;
LTER USER test_simple_user WITH PASSWORD 'qwerty';
```


- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

```yaml
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.orders, public.clients TO test_simple_user;

```

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
```yaml
 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |      Access privileges
-----------+----------+----------+------------+------------+------------------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                 +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres                 +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/postgres                +
           |          |          |            |            | postgres=CTc/postgres       +
           |          |          |            |            | test_admin_user=CTc/postgres
(4 rows)

```
- описание таблиц (describe)
```yaml

test_db=# \d+
                      List of relations
 Schema |  Name   | Type  |  Owner   |  Size   | Description
--------+---------+-------+----------+---------+-------------
 public | clients | table | postgres | 0 bytes |
 public | orders  | table | postgres | 0 bytes |
(2 rows)

test_db=# \d+ orders
                                      Table "public.orders"
 Column |     Type      | Collation | Nullable | Default | Storage  | Stats target | Description
--------+---------------+-----------+----------+---------+----------+--------------+-------------
 id     | integer       |           | not null |         | plain    |              |
 name   | character(50) |           |          |         | extended |              |
 price  | integer       |           |          |         | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_fkey" FOREIGN KEY ("order") REFERENCES orders(id) ON UPDATE RESTRICT ON DELETE SET NULL
Access method: heap

test_db=# \d+ clients
                                      Table "public.clients"
  Column  |     Type      | Collation | Nullable | Default | Storage  | Stats target | Description
----------+---------------+-----------+----------+---------+----------+--------------+-------------
 id       | integer       |           | not null |         | plain    |              |
 lastname | character(50) |           | not null |         | extended |              |
 country  | character(50) |           | not null |         | extended |              |
 order    | integer       |           | not null |         | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_country" btree (country)
Foreign-key constraints:
    "clients_order_fkey" FOREIGN KEY ("order") REFERENCES orders(id) ON UPDATE RESTRICT ON DELETE SET NULL
Access method: heap


```
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

```
SELECT * FROM information_schema.table_privileges WHERE grantee in ('test_admin_user','test_simple_user');
 grantor  |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
----------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 postgres | test_simple_user | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test_simple_user | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test_simple_user | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | INSERT         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | SELECT         | NO           | YES
 postgres | test_admin_user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | DELETE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 postgres | test_admin_user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test_simple_user | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test_simple_user | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | INSERT         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | SELECT         | NO           | YES
 postgres | test_admin_user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | DELETE         | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 postgres | test_admin_user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
(22 rows)

```
## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

```yaml
test_db=# INSERT INTO orders
(id, name,price)
VALUES
(1, 'Шоколад',10),
(2, 'Принтер',3000),
(3, 'Книга',500),
(4, 'Монитор',7000),
(5, 'ГИтара',4000);
INSERT 0 5

```

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|


```yaml
INSERT INTO clients ("id","lastname","country","order")
VALUES
(1, 'Иванов Иван Иванович','USA', 3),
(2, 'Петров Петр Петрович', 'Japan', 4),
(3, 'Иоганн Себастьян Бах', 'Russia', 5),
(4, 'Ронни Джеймс Дио', 'Russia', 1),
(5, 'Ritchie Blackmore', 'Russia', 2);
```
Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

```yaml
test_db=# SELECT COUNT (*) FROM clients;
 count
-------
     5
(1 row)

test_db=# SELECT COUNT (*) FROM orders;
 count
-------
     5
(1 row)

```
## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

```yaml
test_db=# update clients set "order"=3 where lastname='Иванов Иван Иванович';
UPDATE 1
test_db=# update clients set "order"=4 where lastname='Петров Петр Петрович';
UPDATE 1
test_db=# update clients set "order"=5 where lastname='Иоганн Себастьян Бах';
UPDATE 1

```
Приведите SQL-запросы для выполнения данных операций.
Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
```
test_db=# select * from clients where "order" is not null;
 id |                      lastname                      |                      country                       | order
----+----------------------------------------------------+----------------------------------------------------+-------
  2 | Петров Петр Петрович                               | Japan                                              |     4
  3 | Иоганн Себастьян Бах                               | Russia                                             |     5
  4 | Ронни Джеймс Дио                                   | Russia                                             |     1
  5 | Ritchie Blackmore                                  | Russia                                             |     2
  1 | Иванов Иван Иванович                               | USA                                                |     3
(5 rows)
```
_**Тут нюанс при создании таблицы выставил то, что поле заказа не нулевое и поэтому пришлось забить туда ключи тоже, но в идела если там пусто - их не выдаст =)**_
Подсказк - используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

```yaml
test_db=# explain select * from clients where "order" is not null;
                         QUERY PLAN
------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..11.80 rows=179 width=416)
   Filter: ("order" IS NOT NULL)
(2 rows)

```
_**
cost - стоимость запуска и общая стоимость запуска (Примерная). Стоимость исч. 
row - число строк вывода (ожидаемое)
width - средний размер выводимых строк в байтах (ожидаемый)**_
## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

```pg_dump -U postgres -h localhost -F c -f /backup/test_db.dump test_db```

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

```yaml
[root@localhost docker62]# docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED       STATUS       PORTS                                       NAMES
19e9357702be   adminer       "entrypoint.sh docke…"   5 hours ago   Up 5 hours   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   docker62-adminer-1
a0995cac78b2   postgres:12   "docker-entrypoint.s…"   5 hours ago   Up 5 hours   5432/tcp                                    docker62-db-1
[root@localhost docker62]# docker stop docker62-db-1
docker62-db-1
[root@localhost docker62]# docker rm docker62-db-1
docker62-db-1
[root@localhost docker62]# docker stop docker62-adminer-1
docker62-adminer-1
[root@localhost docker62]# docker rm docker62-adminer-1
docker62-adminer-1
[root@localhost docker62]#

```

Поднимите новый пустой контейнер с PostgreSQL.
```
docker compose -f docker-compose up -d
```
```yaml
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(3 rows)


```

Восстановите БД test_db в новом контейнере.

```yaml
 pg_restore -h localhost -U postgres -F c -d test_db /backup/test_db.dump
```

```yaml
test_db=# \d+ orders
                                      Table "public.orders"
 Column |     Type      | Collation | Nullable | Default | Storage  | Stats target | Description
--------+---------------+-----------+----------+---------+----------+--------------+-------------
 id     | integer       |           | not null |         | plain    |              |
 name   | character(50) |           |          |         | extended |              |
 price  | integer       |           |          |         | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_fkey" FOREIGN KEY ("order") REFERENCES orders(id) ON UPDATE RESTRICT ON DELETE SET NULL
Access method: heap

test_db=# \d+ clients
                                      Table "public.clients"
  Column  |     Type      | Collation | Nullable | Default | Storage  | Stats target | Description
----------+---------------+-----------+----------+---------+----------+--------------+-------------
 id       | integer       |           | not null |         | plain    |              |
 lastname | character(50) |           | not null |         | extended |              |
 country  | character(50) |           | not null |         | extended |              |
 order    | integer       |           | not null |         | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_country" btree (country)
Foreign-key constraints:
    "clients_order_fkey" FOREIGN KEY ("order") REFERENCES orders(id) ON UPDATE RESTRICT ON DELETE SET NULL
Access method: heap

```
Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
