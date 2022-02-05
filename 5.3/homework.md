# 5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```html
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

Ответ:  
[nginx-netology](https://hub.docker.com/r/yuts/nginx-netology)  
Страничку поместил в [index.html](./index.html)  
И сам [Dockerfile](./Dockerfile)

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;  
Если возможна настройка балансировки нагрузки через какой-нибудь haproxy, то лучше применить контейнеризацию. Выбор обоснован удобством переноса между хостами и масштабированием приложения.  
- Nodejs веб-приложение;  
Контейнеризация. Упрощает разворачивание, перенос и масштабирование.  
- Мобильное приложение c версиями для Android и iOS;  
Не нашёл указаний на возможность запуска мобильных ОС в контейнерах, так что только ВМ.  
- Шина данных на базе Apache Kafka;  
Не сталкивался и не работал с продуктом. Прибег к гуглу. Получив ответ - могу сказать, что можно смело контейнеризировать.  
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;  
Контейнеризация. Упрощает кластеризацию (особенно если используется compose и ему подобные) + сэкономим ресурсы хоста не поднимая полноценное окружение ВМ.  
- Мониторинг-стек на базе Prometheus и Grafana;  
На клиентах всё равно придётся ставить exporter в обычном режиме, но серверную часть можно запихнуть в контейнеры.  
- MongoDB, как основное хранилище данных для java-приложения;  
Можно и в контейнер, но я старовер и предпочитаю базы данных выносить на полностью виртуализированные ВМ с СУБД.  
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.  
Думаю, что обычная ВМ. Так как это не столь часто обновляющиеся среды, да и масштабировать вряд ли понадобится.

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

Ответ:  
```bash
❯ mkdir /tmp/data-5.3/
❯ sudo docker run -it -d --rm --name 5.3-centos -v /tmp/data-5.3:/data centos
❯ sudo docker run -it -d --rm --name 5.3-debian -v /tmp/data-5.3:/data debian
```
```bash
❯ sudo docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED              STATUS              PORTS     NAMES
2e9314df4b2c   debian    "bash"        16 seconds ago       Up 12 seconds                 5.3-debian
711a39fe09b3   centos    "/bin/bash"   About a minute ago   Up About a minute             5.3-centos
```
```bash
❯ sudo docker exec -it 5.3-centos /bin/bash
[root@711a39fe09b3 /]# cat /etc/*relea* > /data/centos
[root@711a39fe09b3 /]# exit
❯ cat /etc/*relea* > /tmp/data-5.3/host
❯ sudo docker exec -it 5.3-debian /bin/bash
root@2e9314df4b2c:/# for F in $(ls /data) ;do echo File is $F ; echo --- ; cat /data/$F ; echo ; done
File is centos
---
CentOS Linux release 8.4.2105
Derived from Red Hat Enterprise Linux 8.4
NAME="CentOS Linux"
VERSION="8"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="8"
PLATFORM_ID="platform:el8"
PRETTY_NAME="CentOS Linux 8"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:8"
HOME_URL="https://centos.org/"
BUG_REPORT_URL="https://bugs.centos.org/"
CENTOS_MANTISBT_PROJECT="CentOS-8"
CENTOS_MANTISBT_PROJECT_VERSION="8"
CentOS Linux release 8.4.2105
CentOS Linux release 8.4.2105
cpe:/o:centos:centos:8

File is host
---
Manjaro Linux
DISTRIB_ID=ManjaroLinux
DISTRIB_RELEASE=21.2.2
DISTRIB_CODENAME=Qonos
DISTRIB_DESCRIPTION="Manjaro Linux"
Manjaro Linux
NAME="Manjaro Linux"
ID=manjaro
ID_LIKE=arch
BUILD_ID=rolling
PRETTY_NAME="Manjaro Linux"
ANSI_COLOR="32;1;24;144;200"
HOME_URL="https://manjaro.org/"
DOCUMENTATION_URL="https://wiki.manjaro.org/"
SUPPORT_URL="https://manjaro.org/"
BUG_REPORT_URL="https://bugs.manjaro.org/"
LOGO=manjarolinux
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.
