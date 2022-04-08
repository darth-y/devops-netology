# 5.2. Применение принципов IaaC в работе с виртуальными машинами

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.  
Ответ: Вижу основными преимуществами:
  - минимизация (в идеале - полное исключение) дрейфа конфигураций;
  - возможность быстрого (в случае аппаратной подготовленности инфраструктуры) и точного воспроизведения тестовой/боевой среды;
  - при применении необходимых инструментов возможно сохранение истории версий кода и конфигураций, что даёт возможность "отката" и эдакого бэкапа.
- Какой из принципов IaaC является основополагающим?  
Ответ: идемпотентность - получение стабильного и предсказуемого результата при повторных запусках того же кода/конфигурации.

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?  
Ответ: Работает в безагентном режиме, используя "штатный" ssh. Работая в режиме push - сразу даёт понять, если на какую-то из машин не смог доставить конфигурацию.
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?  
Ответ: думаю, что push. При таком подходе обеспечивается централизация не только управления конфигурацией, но и некая гарантия доставки - за счёт того, что сразу ясен результат применения.

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*  
Ответ:  
```bash
❯ python -V
Python 3.9.2
❯ vagrant -v
Vagrant 2.2.19
❯ ansible --version
ansible [core 2.12.1]
  config file = None
  configured module search path = ['/home/user/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /home/user/.local/lib/python3.9/site-packages/ansible
  ansible collection location = /home/user/.ansible/collections:/usr/share/ansible/collections
  executable location = /home/user/.local/bin//ansible
  python version = 3.9.2 (default, Feb 28 2021, 17:03:44) [GCC 10.2.1 20210110]
  jinja version = 3.0.3
  libyaml = True
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```