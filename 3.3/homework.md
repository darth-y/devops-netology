# 3.3. Операционные системы, лекция 1
1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.

```
vagrant@vagrant:~$ strace /bin/bash -c 'cd /tmp' 2>&1 | grep \/tmp
execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffe99d85a20 /* 23 vars */) = 0
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=3428352, ...}) = 0
chdir("/tmp")
```

Ответ: `chdir("/tmp")`

1. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.

```
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
```

Эту же информацию нашёл в man:
```
FILES
/usr/share/misc/magic.mgc  Default compiled list of magic.
/usr/share/misc/magic      Directory containing default magic files.
```

1. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

```
vagrant@vagrant:~$ ping ya.ru >> /tmp/ping.log &
vagrant@vagrant:~$ rm /tmp/ping.log
vagrant@vagrant:~$ ps aux | grep ping
vagrant     2714  0.0  0.2   7208  2708 pts/1    S+   19:04   0:00 ping ya.ru
vagrant     2717  0.0  0.0   6300   740 pts/0    S+   19:04   0:00 grep --color=auto ping
vagrant@vagrant:~$ sudo lsof -p 2714
COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
...
ping    2714 vagrant    1w   REG  253,0      2840 1572875 /tmp/ping.log (deleted)
...
cat /dev/null | sudo tee /proc/2714/fd/1
vagrant@vagrant:~$ sudo lsof -p 2714
COMMAND  PID    USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
...
ping    2714 vagrant    1w   REG  253,0      142 1572875 /tmp/ping.log (deleted)
```

1. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

В отличие от "сирот", "зомби" не используют системных ресурсов, но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом. Существуют до тех пор, пока родительский процесс не прочитает его статус с помощью системного вызова `wait()`.

1. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

```
vagrant@vagrant:~$ sudo opensnoop-bpfcc
PID    COMM               FD ERR PATH
639    irqbalance          6   0 /proc/interrupts
639    irqbalance          6   0 /proc/stat
639    irqbalance          6   0 /proc/irq/20/smp_affinity
639    irqbalance          6   0 /proc/irq/0/smp_affinity
639    irqbalance          6   0 /proc/irq/1/smp_affinity
639    irqbalance          6   0 /proc/irq/8/smp_affinity
639    irqbalance          6   0 /proc/irq/12/smp_affinity
639    irqbalance          6   0 /proc/irq/14/smp_affinity
639    irqbalance          6   0 /proc/irq/15/smp_affinity
```

1. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

Выдержка из `strace`
```
uname({sysname="Linux", nodename="vagrant", ...}) = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0
```

Информация имеется в `man 2 uname`
```
uname()  returns  system information in the structure pointed to by buf.  The utsname struct
       is defined in <sys/utsname.h>:

           struct utsname {
               char sysname[];    /* Operating system name (e.g., "Linux") */
               char nodename[];   /* Name within "some implementation-defined
                                     network" */
               char release[];    /* Operating system release (e.g., "2.6.28") */
               char version[];    /* Operating system version */
               char machine[];    /* Hardware identifier */
           #ifdef _GNU_SOURCE
               char domainname[]; /* NIS or YP domain name */
           #endif
           };
```

```
vagrant@vagrant:~$ cat /proc/sys/kernel/{ostype,hostname,osrelease,version,domainname}
```

1. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?

`;` - разделитель последовательных команд
`&&` - условный оператор

`test -d /tmp/some_dir && echo Hi` - `echo` будет выполнено только при успехе `test`

`set  -e` - Выйти незамедлительно, если команда вернула ненулевой код возврата.
Смысла применять одновременно и `set -e` и `&&` нет - так как при ошибке выполнения первой команды вторая итак не будет выполнена.
	
1. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?

`-e` - прерывает выполнение незамедлительно при ненулевом коде возврата любой команды 
`-x` - вывод трейса простых команд 
`-u` - не заданные параметры и переменные считаются как ошибки, с выводом в stderr текста ошибки
`-o pipefail` - возвращает код возврата последовательности команд; ненулевой для любой ошибочной в почледовательности или 0 для успешного выполнения всех команд.

Полезность для сценариев: 
	- повышает детализацию вывода;
	- завершает сценарий при наличии ошибок, на любом этапе кроме последней команды.

1. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

`S` - процессы, ожидающие завершения (события завершения)
`I` - бездействующие процессы ядра
