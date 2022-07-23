# Дипломное задание по курсу «DevOps-инженер»

## Что необходимо для использования
1. Оплаченный аккаунт в Яндекс облаке
2. Купленный и сделегированный домен
3. Установленный и настроенный terraform и ansible

## Terraform
Готовит инфраструктуру в [Yandex.cloud](https://console.cloud.yandex.ru).  
Вся конфигурация расположена в [./terraform](./terraform).  
Для корректной работы необходимо выбрать один из workspace:  
```bash
terraform workspace list
  default
  prod
* stage
```

При запуске `terraform apply`.  
Cоздаются записи в зоне amabam.ru (сделегирована на NS yandex):  
 - dns.tf  

Создаются сети/подсети:  
 - network.tf  

ВМ создаются набором скриптов:  
 - proxy.tf - реверс-прокси на nginx  
 - app.tf - wordpress  
 - git.tf - gitlab  
 - monitoring.tf - стек мониторинга  
 - mysql.tf - БД  

Настойки провайдера и некоторые переменные вынесены в:  
 - provider.tf  
 - variables.tf  

Блок настроек и вызов ansible:  
 - ansible.tf  
 - inventory.tf  
 - hosts.tf  

## Ansible
Вся конфигурация расположена в [./ansible](./ansible).  
[./ansible/play.yml](./ansible/play.yml) применится на [./ansible/inventory.yml](./ansible/inventory.yml), ранее сгенерированный Terraform.

### Задачи, решаемые в play.yml
 - Скопировать на все хосты локальный файл [./ansible/files/hosts](./ansible/files/hosts), предварительно формируемый terraform.  
 - В конце плейбука перезапустить nginx на машине-прокси
### Задачи, решаемые в roles
 - [nodeexporter](./ansible/roles/nodeexporter)  
Ставится на все хосты для выгрузки метрик
 - [nginx](./ansible/roles/nginx).  
Ставится на ВМ, имеющую белый IP.
Настраивает проксирование трафика изнутри наружу, для того, чтобы ВМ без белых IP имели возможность скачивать что-либо из интернета.  
Настраивает реверс-прокси к вннутренним веб-ресурсам.  
 - [mysql](./ansible/roles/mysql)  
Ставится на пару ВМ из группы db.  
Устанавливает mysql и настраивает репликацию. Роль master отходит первой машине.  
Создаёт базу для wordpress.
 - [wordpress](./ansible/roles/wordpress)
Ставится на ВМ из группы app.  
Удаляет apache2 и ставит nginx.  
Устанавливает wordpress.  
 - [gitlab](./ansible/roles/gitlab)
Ставится на ВМ из группы git.  
Добавляет репозитории и устанавливает self-hosted gitlab-ce.  
 - [monitoring](./ansible/roles/monitoring)
Ставится на ВМ из группы monitoring.  
Устанавливает Prometheus и нацеливает на список таргетов. Связывает с Alertmanager.  
Устанвлвивает Alertmanager и создаёт набор правил алертинга.  
Устанавливает Grafana и создаёт ей набор дашбордов.

## Gitlab CI/CD
Для автоматизации доставки изменений на Wordpress составлены настройки pipeline в Gitlab.  
Конфигурация в [./git-conf/](./git-conf/)

Перед использованием необходимо подготовить репозиторий и gitlab-runner:
1. Заходим в локальный gitlab.  
2. Создаем новый публичный репозиторий.  
3. Копируем любым доступным способом в этот репозиторий файлы из каталога [git-conf](../git-conf)
4. В настройках находим и копируем токен доступа (Settings-CI/CD-Runners), вписываем его в переменную `runner_token` в файле [./ansible/group_vars/app.yml](./ansible/group_vars/app.yml)
5. Для запуска пайплайнов необходимо подготовить ВМ с Wordpress, развернув на ней gitlab-runner и wp-cli:  
```bash
$ cd ansible
$ ansible-playbook ../git-conf/prepare.yml -i inventory.yml -l app 
```

## Скриншоты и логи
### Домен
Приобретён в reg.ru  
![](scrns/09_domain.png)
### Вывод `terraform plan`
Приведён в [scrns/terraform_plan.log](scrns/terraform_plan.log).  
### Мониторинг
![](scrns/04_grafana.png)  
![](scrns/05_promet.png)  
![](scrns/06_alert.png)  
### Gitlab
Общий вид репозитория под WP:  
![](scrns/03_git.png)  
Работа pipeline:  
![](scrns/07_git-pipe.png)  
### Wordpress (до и после отработки pipeline)
![](scrns/01_wp-admin.png)  
![](scrns/02_wp.png)  
![](scrns/08_wp-change.png)  

_Студент: Дмитрий Ю._
