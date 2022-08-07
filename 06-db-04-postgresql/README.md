# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

[docker-compose.yml](docker-compose.yml).
```
docker exec -it db psql -U postgres
```

**Найдите и приведите** управляющие команды для:
- вывода списка БД
```
\l[+]   [PATTERN]      list databases

admin=# \l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges 
-----------+-------+----------+------------+------------+-------------------
 admin     | admin | UTF8     | en_US.utf8 | en_US.utf8 | 
 postgres  | admin | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +
           |       |          |            |            | admin=CTc/admin
 template1 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +
           |       |          |            |            | admin=CTc/admin
(4 rows)
```
- подключения к БД
```
\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}

admin=# \c
You are now connected to database "admin" as user "admin".
```
- вывода списка таблиц
```
\dt[S+] [PATTERN]      list tables

admin=# \dtS
                      List of relations
   Schema   |              Name               | Type  | Owner 
------------+---------------------------------+-------+-------
 pg_catalog | pg_aggregate                    | table | admin
 pg_catalog | pg_am                           | table | admin
 pg_catalog | pg_amop                         | table | admin
 ...
```
- вывода описания содержимого таблиц
```
\d[S+]  NAME           describe table, view, sequence, or index

admin=# \dS+ pg_stats
                                 View "pg_catalog.pg_stats"
         Column         |   Type   | Collation | Nullable | Default | Storage  |
 Description 
------------------------+----------+-----------+----------+---------+----------+
-------------
 schemaname             | name     |           |          |         | plain    |
 
 tablename              | name     |           |          |         | plain    |
 
 attname                | name     |           |          |         | plain    |
 
 inherited              | boolean  |           |          |         | plain    |
 
 null_frac              | real     |           |          |         | plain    |
 
 avg_width              | integer  |           |          |         | plain    |
 
 n_distinct             | real     |           |          |         | plain    |
 
 most_common_vals       | anyarray |           |          |         | extended |
 
 most_common_freqs      | real[]   |           |          |         | extended |
 ...
```
- выхода из psql
```
\q quit psql
```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

```
docker exec -it db psql -U postgres
CREATE DATABASE test_database;

docker exec -it db psql -U postgres -d test_database -f /dump/test_dump.sql
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
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE


docker exec -it db psql -U postgres -d test_database

ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE


SELECT MAX(avg_width) FROM pg_stats where tablename = 'orders';
 max 
-----
  16
(1 row)
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Помогла статья https://www.postgresql.org/docs/current/ddl-partitioning.html

В доках сказано, что при создании таблицы можно сразу указать границы значений, тогда исключить ручное разбиение можно.
Также в доках указан пример с датами, где они это разбиение будут продолжать делать, спустя время, и
хорошо было бы написать автоматический генератор этого разделения. Т.е. исходя из ситуации. В нашем случае можно.

Т.к. таблица заполнена данными, по условиям которых нужно разделить, придется копированием заниматься.
Т.к. данных мало, то можно одним запросом скопировать целиком значения из одной таблицы, и вставить в другую.
На prod скорей всего нужно было бы делать итерациями, иначе базу бы положили.
```
BEGIN;

ALTER TABLE orders RENAME TO orders_old;

CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
) partition by range(price);
CREATE TABLE orders_2 partition of orders for values from (0) to (499);
CREATE TABLE orders_1 partition of orders for values from (499) to (99999);
INSERT INTO orders (id, title, price) SELECT * FROM orders_old;

DROP TABLE orders_old;

COMMIT;
```

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

```
docker exec -t db pg_dump -U postgres test_database -f /dump/dump_db.sql

Можно при создании обычной таблицы добавить UNIQUE
CREATE TABLE orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0,
    UNIQUE (title)
);

Либо сразу после её создания
ALTER TABLE orders ADD UNIQUE (title);

Т.к. postgres не поддерживает глобальные индексы в разделенных таблицах, как oracle, то можно для каждой разделенной таблицы сделать это, 
но эта уникальность будет только в видимости одной разделенной таблицы, т.е. в двух разделенных могут встречаться дубли
ALTER TABLE orders_1 ADD UNIQUE (title);
ALTER TABLE orders_2 ADD UNIQUE (title);

Я пробовал узнать, как postgres будет себя вести, если попробовать сразу создать разделенную таблицу с уникальным полем, но он возвращает ошибку
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
) partition by range(price);
ERROR:  unique constraint on partitioned table must include all partitioning columns

Предоставление дампа в таком случае не имеет смысла
```