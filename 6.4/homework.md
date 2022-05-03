# 6.4. PostgreSQL

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.  
Подключитесь к БД PostgreSQL используя `psql`.  
Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

Ответ:  
```docker
docker run -d --name=6.4_pgs -e POSTGRES_PASSWORD=Qwerty@12 -v /tmp/test_data/data:/var/lib/postgresql/data -v /tmp/test_data:/var/lib/postgresql/backup postgres:13.6-bullseye 
docker exec -it 6.4_pgs psql -U postgres -W postgres
```  
**Найдите и приведите** управляющие команды для:
- вывода списка БД: `\l+`
- подключения к БД: `\c`
- вывода списка таблиц: `\dt`
- вывода описания содержимого таблиц: `\dtS+`
- выхода из psql: `\q`

## Задача 2

Используя `psql` создайте БД `test_database`.  
Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/virt-11/06-db-04-postgresql/test_data).  
Восстановите бэкап БД в `test_database`.  
Перейдите в управляющую консоль `psql` внутри контейнера.  
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.  
Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` с наибольшим средним значением размера элементов в байтах.  
**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

Ответ:  
```bash
docker exec -it 6.4_pgs psql -U postgres -W -c 'CREATE DATABASE test_database WITH OWNER=postgres'
docker exec -it 6.4_pgs bash
root@68cedbbeb957:/# psql -U postgres -W test_database < /var/lib/postgresql/backup/test_dump.sql
root@68cedbbeb957:/# psql -U postgres -W test_database
test_database=# ANALYZE VERBOSE public.orders;
test_database=# select tablename,attname,avg_width from pg_stats where tablename='orders' and avg_width=(select max(avg_width) from pg_stats where tablename='orders');
4 tablename | attname | avg_width 
-----------+---------+-----------
 orders    | title   |        16
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Ответ:  
```sql
test_database=# alter table orders rename to orders_base;
ALTER TABLE
test_database=# create table orders_le499 partition of orders for values from (0) to (500);
CREATE TABLE
test_database=# create table orders_ge500 partition of orders for values from (500) to (999999999);
CREATE TABLE
test_database=# insert into orders (id, title, price) select * from orders_base;
INSERT 0 8
```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

Ответ: Да. На этапе проектирование можно было создать таблицу как секционированную ([https://postgrespro.ru/docs/postgresql/13/ddl-partitioning](https://postgrespro.ru/docs/postgresql/13/ddl-partitioning))

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.  
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

Ответ:  
```bash
root@68cedbbeb957:/# pg_dump -U postgres -W -d test_database > /var/lib/postgresql/backup/test_dump_2.sql
Password:
```  
Для уникальности можно добавить индекс или первичный ключ:  
`CREATE INDEX ON orders ((lower(title)));`
