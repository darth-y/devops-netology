# 3.4. Операционные системы, лекция 2

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

```bash
root@vagrant:~# systemctl cat node_exporter@
# /etc/systemd/system/node_exporter@.service
[Unit]
Description=Daemon for node_exporter on host %H with option %i
Documentation=https://github.com/prometheus/node_exporter
After=network.target

[Service]
Environment=LOG_FILE=/tmp/node_exporter.log
#ExecStart=/opt/node_exporter/1.3.1/node_exporter
ExecStart=/bin/bash -c '/opt/node_exporter/1.3.1/node_exporter  --log.level=%i'
KillMode=process
Restart=always

[Install]
WantedBy=multi-user.target
root@vagrant:~# systemctl daemon-reload
root@vagrant:~# systemctl start node_exporter@warn
root@vagrant:~# systemctl status node_exporter@warn
● node_exporter@warn.service - Daemon for node_exporter on host vagrant with option warn
     Loaded: loaded (/etc/systemd/system/node_exporter@.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2022-01-12 23:14:22 MSK; 39s ago
       Docs: https://github.com/prometheus/node_exporter
   Main PID: 3588 (node_exporter)
      Tasks: 5 (limit: 1071)
     Memory: 2.5M
     CGroup: /system.slice/system-node_exporter.slice/node_exporter@warn.service
             └─3588 /opt/node_exporter/1.3.1/node_exporter --log.level=warn

Jan 12 23:14:22 vagrant systemd[1]: Started Daemon for node_exporter on host vagrant with option warn.
Jan 12 23:14:22 vagrant bash[3588]: ts=2022-01-12T20:14:22.618Z caller=node_exporter.go:185 level=war>
```
	
1. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

Ответ:  
CPU:  
- node_cpu_seconds_total{cpu="0",mode="idle"} 8511.61
- node_cpu_seconds_total{cpu="0",mode="system"} 9.65
RAM:  
- node_memory_MemFree_bytes 1.6750592e+08
- node_memory_MemTotal_bytes 1.028685824e+09
- node_memory_SwapFree_bytes 2.057302016e+09
- node_memory_SwapTotal_bytes 2.057302016e+09
HDD:
- node_disk_read_bytes_total{device="sda"} 5.6425472e+08  
- node_disk_reads_completed_total{device="sda"} 19580
- node_disk_writes_completed_total{device="sda"} 5686
Net:  
- node_network_info{address="08:00:27:b1:28:5d",broadcast="ff:ff:ff:ff:ff:ff",device="eth0",duplex="full",ifalias="",operstate="up"} 1
- node_network_receive_bytes_total{device="eth0"} 1.0861247e+07
- node_network_transmit_bytes_total{device="eth0"} 750427
- node_network_up{device="eth0"} 1

1. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

```
vagrant@vagrant:~$ sudo netstat -nap | grep 999
tcp        0      0 0.0.0.0:19999           0.0.0.0:*               LISTEN      2299/netdata
tcp        0      0 10.0.2.15:19999         10.0.2.2:61706          ESTABLISHED 2299/netdata
```  
![Netdata](./3.4.3_01.png?raw=true)

1. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

Система детектирует виртуализацию Oracle:  
```
vagrant@vagrant:~$ sudo dmesg | grep -i virtua
[    0.000000] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[    0.003840] CPU MTRRs all blank - virtualized system.
[    0.129265] Booting paravirtualized kernel on KVM
[    6.732763] systemd[1]: Detected virtualization oracle.
```

1. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?

Ответ:  
`fs.nr_open` - Максимальное количество файловых дескрипторов, которые может выделить процесс. Значение по умолчанию — 1024*1024 (1048576). [ист.](https://sysctl-explorer.net/fs/nr_open/)  
Имеются также т.н. мягкий лимит:
```
vagrant@vagrant:~$ ulimit -Sn
1024
```
и жесткий лимит
```
vagrant@vagrant:~$ ulimit -Hn
1048576
```


1. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.

```
root@vagrant:~# ps -e | grep sleep
   2822 pts/1    00:00:00 sleep
root@vagrant:~# nsenter --target 2822 --pid --mount
root@vagrant:/# ps
    PID TTY          TIME CMD
      2 pts/0    00:00:00 bash
     14 pts/0    00:00:00 ps
```

1. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

Ответ: однострочник определяет и запускает функцию `:`, которая порождает саму себя (используя системный вызов `fork()`). Это один из скриптов класса forkbomb.  
Я так понимаю, что от полного падения спасло ограничение кол-ва возможных процессов, так как пошли сообщения в `dmesg`: `cgroup: fork rejected by pids controller ...`.  
Дополнительно защититься можно, например ограничив кол-во пользовтаельских процессов `ulimit -u 100`
