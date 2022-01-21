# 4.2. Использование Python для решения типовых DevOps задач

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ                                          |
| ------------- |------------------------------------------------|
| Какое значение будет присвоено переменной `c`?  | TypeError. Так как пытаемся сложить int и str. |
| Как получить для переменной `c` значение 12?  | c = str(a) + b                                            |
| Как получить для переменной `c` значение 3?  | c = a + int(b)                                            |

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
Убрал неиспользуемую переменную `is_change` и исправил пути/локализацию под своё окружение.
```python
#!/usr/bin/env python3

import os

bash_command = ["cd /home/user/Документы/devops-netology", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = result.replace('\tизменено:      ', '/home/user/Документы/devops-netology/')
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```bash
❯ ~/wip_4.2.2.py
/home/user/Документы/devops-netology/.gitignore
/home/user/Документы/devops-netology/4.2/homework.md
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

if len(sys.argv) < 2:
    print("Using current dir: %s"%(os.getcwd()))
    git_dir = os.getcwd()
elif len(sys.argv) > 2:
    print("We use only one path at moment!")
    sys.exit()
else:
    print("Using argument dir: %s"%(sys.argv[1]))
    git_dir = sys.argv[1]

bash_command = ["cd " + git_dir, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
for result in result_os.split('\n'):
    if result.find('изменено') != -1:
        prepare_result = result.replace('\tизменено:      ', '/home/user/Документы/devops-netology/')
        print(prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```bash
❯ ./wip_4.2.2.py
Using current dir: /home/user
fatal: не найден git репозиторий (или один из его каталогов вплоть до точки монтирования /)
Останавливаю поиск на границе файловой системы (так как GIT_DISCOVERY_ACROSS_FILESYSTEM не установлен).
❯ ./wip_4.2.2.py /tmp /var
We use only one path at moment!
❯ ./wip_4.2.2.py /opt
Using argument dir: /opt
fatal: не найден git репозиторий (или один из родительских каталогов): .git
❯ ./wip_4.2.2.py /home/user/Документы/devops-netology/
Using argument dir: /home/user/Документы/devops-netology/
/home/user/Документы/devops-netology/.gitignore
/home/user/Документы/devops-netology/4.2/homework.md
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
Позволил себе добавить `sleep` для удобства работы
```python
#!/usr/bin/env python3
import socket
from datetime import datetime
from time import sleep

time_start = datetime.now()
print(datetime.now(),"Script started working")
services = {'drive.google.com':'0.0.0.0', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0'}

# Первичный сбор IP сервисов
for service in services:
    services[service] = socket.gethostbyname(service)

while True:
    for service in services:
        ip = socket.gethostbyname(service)
        if services[service] != ip:
            print(datetime.now(),"[ERROR]", service,"IP mismatch!", services[service],"==>", ip)
            services[service] = ip
        else:
            print(datetime.now(), "[INFO]", service, "IP is:", services[service])
    sleep(5)
```

### Вывод скрипта при запуске при тестировании:
```
2022-01-21 22:38:30.356395 Script started working
2022-01-21 22:38:30.388576 [INFO] drive.google.com IP is: 64.233.165.102
2022-01-21 22:38:30.389585 [INFO] mail.google.com IP is: 74.125.131.83
2022-01-21 22:38:30.389585 [INFO] google.com IP is: 209.85.233.139
2022-01-21 22:38:35.394183 [INFO] drive.google.com IP is: 64.233.165.102
2022-01-21 22:38:35.395159 [ERROR] mail.google.com IP mismatch! 74.125.131.83 ==> 234.234.234.234
2022-01-21 22:38:35.397217 [INFO] google.com IP is: 209.85.233.139
2022-01-21 22:38:40.398109 [ERROR] drive.google.com IP mismatch! 64.233.165.102 ==> 123.123.123.123
2022-01-21 22:38:40.398109 [INFO] mail.google.com IP is: 234.234.234.234
2022-01-21 22:38:40.401040 [INFO] google.com IP is: 209.85.233.139
2022-01-21 22:38:45.402922 [ERROR] drive.google.com IP mismatch! 123.123.123.123 ==> 123.125.123.123
2022-01-21 22:38:45.402922 [INFO] mail.google.com IP is: 234.234.234.234
2022-01-21 22:38:45.448785 [INFO] google.com IP is: 209.85.233.139
2022-01-21 22:38:50.449501 [INFO] drive.google.com IP is: 123.125.123.123
2022-01-21 22:38:50.450443 [INFO] mail.google.com IP is: 234.234.234.234
2022-01-21 22:38:50.451419 [INFO] google.com IP is: 209.85.233.139
2022-01-21 22:38:55.496640 [ERROR] drive.google.com IP mismatch! 123.125.123.123 ==> 64.233.165.102
2022-01-21 22:38:55.543418 [ERROR] mail.google.com IP mismatch! 234.234.234.234 ==> 74.125.131.17
2022-01-21 22:38:55.545363 [INFO] google.com IP is: 209.85.233.139
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```