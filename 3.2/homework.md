# 3.2. Работа в терминале, лекция 2
1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.

`type cd` отвечает, что `cd is a shell builtin`.
Чтобы ответить на вопрос сделал простой shell-скрипт:

![3.2.1_CD](./3.2.1_01.png?raw=true "3.2.1_CD")

Ответ: `cd` встроенная команда и доступна в окружении запущенного терминала, если же пытаться её реализовать сторонними стредствами - то смена директории будет происходить в запущенных дочерних процессах в своем окружении.

2. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`? `man grep` поможет в ответе на этот вопрос. Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.

`grep -c string file`

А указанный документ, к сожалению, не доступен.

3. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

```
vagrant@vagrant:~$ ps -p 1
    PID TTY          TIME CMD
      1 ?        00:00:03 systemd
```

4. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?

`ls err_condition 2> /dev/pts/1`

![3.2.4_01](./3.2.4_01.png?raw=true "3.2.4_pts0")
![3.2.4_02](./3.2.4_02.png?raw=true "3.2.4_pts1")

5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.

![3.2.5_01](./3.2.5_01.png?raw=true "3.2.5_stdin-stdout")

6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

Ответ схож с 4 заданием: `tail -10 /var/log/dmesg > /dev/tty5`
Но есть пара нюансов:
- Поскольку мой пользователь не был авторизован на TTY5 для вывода пришлось повыситься до root. Либо можно было бы использовать конструкцию вида: `tail -10 /var/log/dmesg | sudo tee /dev/tty5`
- Чтобы увидеть вывод необходимо переключиться на указанный TTY (в данном случае по `Ctrl`+`Alt`+`F5`), для этого пришлось открыть консоль ВМ в VirtualBox.

7. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?

`bash 5>&1` - Команда создала дескриптор 5 и перенаправила вывод в stdout.
`echo netology > /proc/$$/fd/5` - Команда вывела в дескриптор 5 текст netology, который был пернеаправлен в stdout. И я смог увидеть его на экране.

8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа.
Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.

```
vagrant@vagrant:/tmp$ du /tmp/ | wc -l
du: cannot read directory '/tmp/systemd-private-bd87ae7bbb534b94947cb4e51c645fe0-fwupd.service-CyOkxi': Permission denied
du: cannot read directory '/tmp/systemd-private-bd87ae7bbb534b94947cb4e51c645fe0-upower.service-oi4cvf': Permission denied
du: cannot read directory '/tmp/snap.lxd': Permission denied
du: cannot read directory '/tmp/systemd-private-bd87ae7bbb534b94947cb4e51c645fe0-systemd-resolved.service-NcRykg': Permission denied
du: cannot read directory '/tmp/systemd-private-bd87ae7bbb534b94947cb4e51c645fe0-systemd-logind.service-FKYuhi': Permission denied
11
vagrant@vagrant:/tmp$ du /tmp/ 5>&1 1>&2 2>&5 | wc -l
4       /tmp/.font-unix
4       /tmp/systemd-private-bd87ae7bbb534b94947cb4e51c645fe0-fwupd.service-CyOkxi
4       /tmp/.Test-unix
4       /tmp/systemd-private-bd87ae7bbb534b94947cb4e51c645fe0-upower.service-oi4cvf
4       /tmp/snap.lxd
4       /tmp/.X11-unix
4       /tmp/.XIM-unix
4       /tmp/systemd-private-bd87ae7bbb534b94947cb4e51c645fe0-systemd-resolved.service-NcRykg
4       /tmp/.ICE-unix
4       /tmp/systemd-private-bd87ae7bbb534b94947cb4e51c645fe0-systemd-logind.service-FKYuhi
3400    /tmp/
5
```

9. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?

Вернёт переменные окружения. Также можно получить их командой `env`

10. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.

Строка: 248
`/proc/[pid]/cmdline` - файл содержит полную командную строку для процесса, если только процесс не является зомби.

Строка: 306
`/proc/<PID>/exe` - символическая ссылка, содержащая фактический путь к исполняемой команде.

11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.

`grep sse /proc/cpuinfo` - sse4_2

12. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:

    ```bash
	vagrant@netology1:~$ ssh localhost 'tty'
	not a tty
    ```

	Почитайте, почему так происходит, и как изменить поведение.

Ответ: так происходит потому что в момент подключения с передачей команды терминала не создаётся. Можно обойти использованием флага `-t` для форсирования создания псевдотерминала.

```
vagrant@vagrant:~$ ssh localhost 'tty'
vagrant@localhost's password:
not a tty
vagrant@vagrant:~$ ssh localhost 'ls'
vagrant@localhost's password:
cd.sh
file
vagrant@vagrant:~$ man ssh
vagrant@vagrant:~$ ssh -t localhost 'tty'
vagrant@localhost's password:
/dev/pts/2
Connection to localhost closed.
```
	
13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.

Воспользовался инструкцией https://github.com/nelhage/reptyr
```
vagrant@vagrant:~$ top
Ctrl+Z
vagrant@vagrant:~$ bg
vagrant@vagrant:~$ jobs -l
vagrant@vagrant:~$ disown top
vagrant@vagrant:~$ screen
```

Далее уже в `screen`
```
vagrant@vagrant:~$ reptyr -T 1174
Ctrl+A+D
```

Отключил сессию ssh и запустил новую.
Нашёл сессию `screen` и продолжил её.
```
vagrant@vagrant:~$ screen -list
vagrant@vagrant:~$ screen -r 1104.pts-0.vagrant
```

14. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.

Команда, выводит на экран и/или перенаправляет вывод команды в файл или переменную.
Вариант с `sudo echo` не сработает так как с повышением срабатывает именно echo, а перенаправление вывод уже происходит от обычного пользователя. Использование конструкций вида `echo string | sudo tee /root/new_file` позволяет повышать привилегии именно на записи в файл.
