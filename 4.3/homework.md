# 4.3. Языки разметки JSON и YAML


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 <=========== Тут вообще не IP
            }
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43" <== Тут были потеряны кавычки "
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import json
import yaml
import socket
from datetime import datetime
from time import sleep

time_start = datetime.now()
print(datetime.now(),"Script started working")
services = {'drive.google.com':'0.0.0.0', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0'}

# Первичный сбор IP сервисов
for service in services:
    services[service] = socket.gethostbyname(service)
with open('wip_4.3.2.json', 'w') as out_json:
    out_json.write(json.dumps(services))
with open('wip_4.3.2.yaml', 'w') as out_yaml:
    yaml.dump(services, out_yaml)
while True:
    for service in services:
        ip = socket.gethostbyname(service)
        if services[service] != ip:
            print(datetime.now(),"[ERROR]", service,"IP mismatch!", services[service],"==>", ip)
            services[service] = ip
            with open('wip_4.3.2.json', 'w') as out_json:
                out_json.write(json.dumps(services))
            with open('wip_4.3.2.yaml', 'w') as out_yaml:
                yaml.dump(services, out_yaml)
        else:
            print(datetime.now(), "[INFO]", service, "IP is:", services[service])
    sleep(5)
```

### Вывод скрипта при запуске при тестировании:
```
2022-01-21 23:11:03.647447 Script started working
2022-01-21 23:11:03.671848 [INFO] drive.google.com IP is: 64.233.165.100
2022-01-21 23:11:03.672825 [INFO] mail.google.com IP is: 74.125.131.83
2022-01-21 23:11:03.672825 [INFO] google.com IP is: 209.85.233.113
2022-01-21 23:11:08.720699 [INFO] drive.google.com IP is: 64.233.165.100
2022-01-21 23:11:08.721675 [ERROR] mail.google.com IP mismatch! 74.125.131.83 ==> 234.234.234.234
2022-01-21 23:11:08.771463 [INFO] google.com IP is: 209.85.233.113
2022-01-21 23:11:13.771502 [INFO] drive.google.com IP is: 64.233.165.100
2022-01-21 23:11:13.772479 [INFO] mail.google.com IP is: 234.234.234.234
2022-01-21 23:11:13.772479 [INFO] google.com IP is: 209.85.233.113
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"drive.google.com": "64.233.165.100", "mail.google.com": "234.234.234.234", "google.com": "209.85.233.113"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
drive.google.com: 64.233.165.100
google.com: 209.85.233.113
mail.google.com: 234.234.234.234
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
???
```

### Пример работы скрипта:
???