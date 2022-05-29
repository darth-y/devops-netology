# 6.6. Troubleshooting

## Задача 1

Перед выполнением задания ознакомьтесь с документацией по [администрированию MongoDB](https://docs.mongodb.com/manual/administration/).

Пользователь (разработчик) написал в канал поддержки, что у него уже 3 минуты происходит CRUD операция в MongoDB и её нужно прервать. 

Вы как инженер поддержки решили произвести данную операцию:
- напишите список операций, которые вы будете производить для остановки запроса пользователя
- предложите вариант решения проблемы с долгими (зависающими) запросами в MongoDB

Ответ:  
Поиск операции: `db.currentOp()`
Завершить операцию по opid: `db.killOp()`

Для борьбы с долгими запросами можно попробовать правильно настроить индексы.

## Задача 2

Перед выполнением задания познакомьтесь с документацией по [Redis latency troobleshooting](https://redis.io/topics/latency).

Вы запустили инстанс Redis для использования совместно с сервисом, который использует механизм TTL. 
Причем отношение количества записанных key-value значений к количеству истёкших значений есть величина постоянная и
увеличивается пропорционально количеству реплик сервиса. 

При масштабировании сервиса до N реплик вы увидели, что:
- сначала рост отношения записанных значений к истекшим
- Redis блокирует операции записи

Как вы думаете, в чем может быть проблема?

Ответ:  
Не работал с redis. Погуглил и думаю, что проблемой может быть банальная нехватка ресурсов при увеличении кол-ва реплик.

## Задача 3

Вы подняли базу данных MySQL для использования в гис-системе. При росте количества записей, в таблицах базы,
пользователи начали жаловаться на ошибки вида:
```python
InterfaceError: (InterfaceError) 2013: Lost connection to MySQL server during query u'SELECT..... '
```

Как вы думаете, почему это начало происходить и как локализовать проблему?  
Какие пути решения данной проблемы вы можете предложить?

Ответ:  
Возможно, из-за роста нагрузки сервер дольше обрабатывает запросы и сбрасываются коннекты.  
Можно попробовать увеличить значения параметров : connect_timeout, interactive_timeout  
Добавить ресурсов под сервис.  
Настроить индексы по популярным запросам.

## Задача 4


Вы решили перевести гис-систему из задачи 3 на PostgreSQL, так как прочитали в документации, что эта СУБД работает с 
большим объемом данных лучше, чем MySQL.

После запуска пользователи начали жаловаться, что СУБД время от времени становится недоступной. В dmesg вы видите, что:

`postmaster invoked oom-killer`

Как вы думаете, что происходит?  
Как бы вы решили данную проблему?

Ответ:  
Кончилась ОЗУ. ОС начинает гасить процессы, чтобы предовтратить общее падение.  
Увеличивать ОЗУ, настроить postgre корректно по лимитам.