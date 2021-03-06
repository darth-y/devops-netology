# Ansible plays for diploma
Для выполнения задачи по установке и первичной конфигурации ПО составлен [play.yml](play.yml), вызывающий в процессе работы роли из [./roles](./roles).  
Используется [](./inventoru.yml)
## Задачи, решаемые в play.yml
 - Скопировать на все хосты локальный файл [./files/hosts](./files/hosts), предварительно формируемый terraform.  
 - В конце плейбука перезапустить nginx на машине-прокси
## Задачи, решаемые в roles
 - [nodeexporter](roles/nodeexporter)  
Ставится на все хосты для выгрузки метрик
 - [nginx](roles/nginx).  
Ставится на ВМ, имеющую белый IP.
Настраивает проксирование трафика изнутри наружу, для того, чтобы ВМ без белых IP имели возможность скачивать что-либо из интернета.  
Настраивает реверс-прокси к вннутренним веб-ресурсам.  
 - [mysql](./roles/mysql)  
Ставится на пару ВМ из группы db.  
Устанавливает mysql и настраивает репликацию. Роль master отходит первой машине.  
Создаёт базу для wordpress.
 - [wordpress](./roles/wordpress)
Ставится на ВМ из группы app.  
Удаляет apache2 и ставит nginx.  
Устанавливает wordpress.  
 - [gitlab](./roles/gitlab)
Ставится на ВМ из группы git.  
Добавляет репозитории и устанавливает self-hosted gitlab-ce.  
 - [monitoring](./roles/monitoring)
Ставится на ВМ из группы monitoring.  
Устанавливает Prometheus и нацеливает на список таргетов. Связывает с Alertmanager.  
Устанвлвивает Alertmanager и создаёт набор правил алертинга.  
Устанавливает Grafana и создаёт ей набор дашбордов.