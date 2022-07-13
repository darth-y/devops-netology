# Playbook for 8.2 homework
## Что делает
Данный плейбук устанавливает:
- java, загружаемую с локального ресурса
- elasticsearch и kibana одинаковых версий, загружаемых из сети
## Параметры
Для работы плейбука потребуется:
- Запустить тестовую среду `docker compose up` ([docker-compose.yml](./docker-compose.yml))
- Загрузить [java](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) и расположить его [./files/](./files)
- Указать версионность java в [./group_vars/all/vars.yml](./group_vars/all/vars.yml)
- Указать версионность ELK в [./group_vars/elasticsearch/vars.yml](./group_vars/elasticsearch/vars.yml)
## Теги
- java
- elastic
- kibana
