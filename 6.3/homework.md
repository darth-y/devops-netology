# 6.3. MySQL

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.  
Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и восстановитесь из него.  
Перейдите в управляющую консоль `mysql` внутри контейнера.  
Используя команду `\h` получите список управляющих команд.  
Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.
Подключитесь к восстановленной БД и получите список таблиц из этой БД.  
**Приведите в ответе** количество записей с `price` > 300.  
В следующих заданиях мы будем продолжать работу с данным контейнером.

Ответ:  
![](./6.3.1_01.png)  
![](./6.3.1_02.png)  
![](6.3.1_03.png)

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Ответ:  
```sql
mysql> create user 'test'@'localhost' identified with mysql_native_password by 'test-pass' ;
Query OK, 0 rows affected (0.02 sec)
mysql> alter user 'test'@'localhost' password expire interval 180 day;
Query OK, 0 rows affected (0.00 sec)
mysql> alter user  'test'@'localhost' FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME UNBOUNDED;
Query OK, 0 rows affected (0.01 sec)
mysql> UPDATE mysql.user SET
    -> max_updates = 100
    -> WHERE user='test' AND host='localhost';
Query OK, 1 row affected (0.01 sec)
Rows matched: 1  Changed: 1  Warnings: 0
mysql> alter user 'test'@'localhost' ATTRIBUTE '{"name":"James","surname":"Pretty"}';
Query OK, 0 rows affected (0.01 sec)
```

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.

Ответ:  
```sql
mysql> GRANT SELECT ON test.* TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.01 sec)
```
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и **приведите в ответе к задаче**.

Ответ:  
![](6.3.2_01.png)

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Ответ:  
![](6.3.3_01.png)

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

Ответ:  
![](6.3.3_02.png)

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

Ответ:  
[my.cnf](./my.cnf)
