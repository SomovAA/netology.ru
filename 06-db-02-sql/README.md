# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

[docker-compose.yml](docker-compose.yml).

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
```
docker exec -it db psql -U admin

CREATE DATABASE test_db;

SELECT * FROM pg_database;
  oid  |  datname  | datdba | encoding | datcollate |  datctype  | datistemplate | datallowconn | datconnlimit | datlastsysoid | datfrozenxid | datminmxid | dattablespace |           datacl           
-------+-----------+--------+----------+------------+------------+---------------+--------------+--------------+---------------+--------------+------------+---------------+----------------------------
 13458 | postgres  |     10 |        6 | en_US.utf8 | en_US.utf8 | f             | t            |           -1 |         13457 |          480 |          1 |          1663 | 
 16384 | admin     |     10 |        6 | en_US.utf8 | en_US.utf8 | f             | t            |           -1 |         13457 |          480 |          1 |          1663 | 
     1 | template1 |     10 |        6 | en_US.utf8 | en_US.utf8 | t             | t            |           -1 |         13457 |          480 |          1 |          1663 | {=c/admin,admin=CTc/admin}
 13457 | template0 |     10 |        6 | en_US.utf8 | en_US.utf8 | t             | f            |           -1 |         13457 |          480 |          1 |          1663 | {=c/admin,admin=CTc/admin}
 16385 | test_db   |     10 |        6 | en_US.utf8 | en_US.utf8 | f             | t            |           -1 |         13457 |          480 |          1 |          1663 | 
(5 rows)

CREATE ROLE "test-admin-user" SUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;

SELECT * FROM pg_catalog.pg_user;
     usename     | usesysid | usecreatedb | usesuper | userepl | usebypassrls |  passwd  | valuntil | useconfig 
-----------------+----------+-------------+----------+---------+--------------+----------+----------+-----------
 admin           |       10 | t           | t        | t       | t            | ******** |          | 
 test-admin-user |    16386 | f           | t        | f       | f            | ******** |          | 
(2 rows)

```
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
```
docker exec -it db psql -U admin -d test_db

CREATE TABLE orders (id integer primary key,name varchar(255),price integer);

CREATE TABLE clients (id integer primary key,lastname varchar(255),country varchar(255),order_id integer,FOREIGN KEY (order_id) REFERENCES orders (id));
```
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db

Мы сразу создали его как SUPERUSER, он обладает всеми привилегиями
- создайте пользователя test-simple-user  
```
CREATE ROLE "test-simple-user" NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;
```
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

```
GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE clients TO "test-simple-user";

GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE orders TO "test-simple-user";

SELECT * FROM information_schema.role_table_grants WHERE grantee IN ('test-simple-user');

 grantor |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
---------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 admin   | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 admin   | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 admin   | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 admin   | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
 admin   | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 admin   | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 admin   | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 admin   | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
(8 rows)
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
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

```
\l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges 
-----------+-------+----------+------------+------------+-------------------
 admin     | admin | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres  | admin | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +
           |       |          |            |            | admin=CTc/admin
 template1 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +
           |       |          |            |            | admin=CTc/admin
 test_db   | admin | UTF8     | en_US.utf8 | en_US.utf8 | 
(5 rows)

\d+
                      List of relations
 Schema |  Name   | Type  | Owner |    Size    | Description 
--------+---------+-------+-------+------------+-------------
 public | clients | table | admin | 8192 bytes | 
 public | orders  | table | admin | 0 bytes    | 
(2 rows)

\du
                                       List of roles
    Role name     |                         Attributes                         | Member of 
------------------+------------------------------------------------------------+-----------
 admin            | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 test-admin-user  | Superuser, No inheritance                                  | {}
 test-simple-user | No inheritance                                             | {}

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

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

```
INSERT INTO orders (id,name,price) VALUES (1, 'Шоколад', 10);
INSERT 0 1
INSERT INTO orders (id,name,price) VALUES (2, 'Принтер', 3000);
INSERT 0 1
INSERT INTO orders (id,name,price) VALUES (3, 'Книга', 500);
INSERT 0 1
INSERT INTO orders (id,name,price) VALUES (4, 'Монитор', 7000);
INSERT 0 1
INSERT INTO orders (id,name,price) VALUES (5, 'Гитара', 4000);
INSERT 0 1

INSERT INTO clients (id,lastname,country) VALUES (1, 'Иванов Иван Иванович', 'USA');
INSERT 0 1
INSERT INTO clients (id,lastname,country) VALUES (2, 'Петров Петр Петрович', 'Canada');
INSERT 0 1
INSERT INTO clients (id,lastname,country) VALUES (3, 'Иоганн Себастьян Бах', 'Japan');
INSERT 0 1
INSERT INTO clients (id,lastname,country) VALUES (4, 'Ронни Джеймс Дио', 'Russia');
INSERT 0 1
INSERT INTO clients (id,lastname,country) VALUES (5, 'Ritchie Blackmore', 'Russia');
INSERT 0 1

SELECT count(*) FROM orders;
 count
-------
     5
(1 row)

SELECT count(*) FROM clients;
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

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

```
UPDATE clients SET order_id = (SELECT id FROM orders WHERE name = 'Шоколад')
WHERE id = (SELECT id FROM clients WHERE lastname = 'Иванов Иван Иванович');

UPDATE clients SET order_id = (SELECT id FROM orders WHERE name = 'Монитор')
WHERE id = (SELECT id FROM clients WHERE lastname = 'Петров Петр Петрович');

UPDATE clients SET order_id = (SELECT id FROM orders WHERE name = 'Гитара')
WHERE id = (SELECT id FROM clients WHERE lastname = 'Иоганн Себастьян Бах');


SELECT c.lastname AS ФИО, o.name AS Заказ FROM orders AS o INNER JOIN clients AS c ON o.id = c.order_id;
         ФИО          |  Заказ  
----------------------+---------
 Иванов Иван Иванович | Шоколад
 Петров Петр Петрович | Монитор
 Иоганн Себастьян Бах | Гитара
(3 rows)
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

```
EXPLAIN SELECT c.lastname, o.name FROM orders o INNER JOIN clients c ON o.id = c.order_id;

                               QUERY PLAN                                
-------------------------------------------------------------------------
1) Hash Join  (cost=11.57..24.20 rows=70 width=1032)
2)   Hash Cond: (o.id = c.order_id)
3)   ->  Seq Scan on orders o  (cost=0.00..11.40 rows=140 width=520)
4)   ->  Hash  (cost=10.70..10.70 rows=70 width=520)
5)         ->  Seq Scan on clients c  (cost=0.00..10.70 rows=70 width=520)
(5 rows)
```

Из официального источника
```
В выводе команды EXPLAIN для каждого узла в дереве плана отводится одна строка, 
где показывается базовый тип узла плюс оценка стоимости выполнения данного узла, 
которую сделал для него планировщик. 
Если для узла выводятся дополнительные свойства, 
в вывод могут добавляться дополнительные строки, 
с отступом от основной информации узла. 
В самой первой строке (основной строке самого верхнего узла) выводится 
общая стоимость выполнения для всего плана; 
именно это значение планировщик старается минимизировать.
```

Расшифруем
```
4 и 5) Здесь планировщик выбирает соединение по хешу, при котором строки одной таблицы записываются в хеш-таблицу в памяти, после чего сканируется другая таблица и для каждой её строки проверяется соответствие по хеш-таблице.

2 и 3) Затем она передаётся узлу Hash Join, который читает строки из узла внешнего потомка и проверяет их по этой хеш-таблице.

1) расшифруем то, что в скобках (cost=11.57..24.20 rows=70 width=1032)
- cost=11.57 - Приблизительная стоимость запуска. Это время, которое проходит, прежде чем начнётся этап вывода данных, например для сортирующего узла это время сортировки.
- cost=24.20 - Приблизительная общая стоимость. Она вычисляется в предположении, что узел плана выполняется до конца, то есть возвращает все доступные строки
- rows=70 - Ожидаемое число строк, которое должен вывести этот узел плана. При этом так же предполагается, что узел выполняется до конца.
- width=1032 - Ожидаемый средний размер строк, выводимых этим узлом плана (в байтах).
```
## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 


Проще целиком сделать бэкап всех БД в postgresql вместе со всеми пользователями и правами
```
docker exec -t db pg_dumpall -U admin -f /dump/dumpall_db.sql

docker stop db

docker exec -it test_db psql -U admin -f /dump/dumpall_db.sql

SET
SET
SET
psql:/dump/dumpall_db.sql:14: ERROR:  role "admin" already exists
ALTER ROLE
CREATE ROLE
ALTER ROLE
CREATE ROLE
ALTER ROLE
You are now connected to database "template1" as user "admin".
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
psql:/dump/dumpall_db.sql:84: ERROR:  database "admin" already exists
ALTER DATABASE
You are now connected to database "admin" as user "admin".
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
COPY 0
ALTER TABLE
You are now connected to database "postgres" as user "admin".
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
CREATE DATABASE
ALTER DATABASE
You are now connected to database "test_db" as user "admin".
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE TABLE
ALTER TABLE
COPY 5
COPY 5
ALTER TABLE
ALTER TABLE
ALTER TABLE
GRANT
GRANT

Process finished with exit code 0

```

Если делать для конкретной, то нужно либо как-то в него относящихся к нему пользователей выгружать, либо отдельно создавать БД с пользователями и правами, далее впитывать данные
```
docker exec -t db pg_dump -U admin test_db -f /dump/dump_db.sql

docker stop db

docker exec -it test_db psql -U admin

CREATE DATABASE test_db;
CREATE ROLE "test-admin-user" SUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;
CREATE ROLE "test-simple-user" NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;

docker exec -it test_db psql -U admin -d test_db -f /dump/dump_db.sql

SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE TABLE
ALTER TABLE
COPY 5
COPY 5
ALTER TABLE
ALTER TABLE
ALTER TABLE
GRANT
GRANT
```