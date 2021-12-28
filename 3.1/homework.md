# 3.1. Работа в терминале, лекция 1
1. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?
![VM in VirtualBox](./vbox_01.png?raw=true "Как выглядит виртуальная машина в VirtualBox")
Выделенные ресурсы:
- CPU: 2 ядра, доступные на 100%
- RAM: 1 GB
- HDD:
  - Виртуальный размер: 64 GB
  - Реальный размер: 2,05 GB

2. Ознакомиться с разделами man bash, почитать о настройках самого bash:
- какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?
`HISTFILESIZE` The maximum number of lines contained in the history file.
Строка: 964
`HISTSIZE` The number of commands to remember in the command history.
Строка: 982
- что делает директива ignoreboth в bash?
```
HISTCONTROL
...If  the  list  of values includes ignorespace, lines which begin with a space character are not saved in the history list.  A  value  of  ignoredups  causes  lines matching the previous history entry to not be saved.  A value of ignoreboth is short hand for ignorespace and ignoredups...
```
Позволит не сохранять в истории команды, начинающие с пробела, и дубликаты

3. В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?
Строка: 293
{ и } - зарезервированные символы для использования при объявлении списков. Используются в циклах, функциях. При использовании в командах - будут подставляться элементы списка.

4. С учётом ответа на предыдущий вопрос, как создать однократным вызовом touch 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?
`touch {000001..100000}`
300000 - не получилось, так как упёрся в ограничение количества аргументов touch.
Максимум сколько пропустило `touch {000001..139652}`, но нигде в man не нашёл описания ограничений.

5. В man bash поищите по `/\[\[`. Что делает конструкция `[[ -d /tmp ]]`
По `[[ ]]` всё понятно - проверка условия внутри скобок. Возвращает истину, когда результат выполнения команды в условии = 0.
А вот про -d нашёл в `man test` (помог Google).
```
-d FILE
    FILE exists and is a directory
```
Т.о. конструкция `[[ -d /tmp ]]` вернёт истину, если файл /tmp существует и он директория.

6. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:
```
bash is /tmp/new_path_directory/bash
bash is /usr/local/bin/bash
bash is /bin/bash
```
Ответ:
```
vagrant@vagrant:/tmp$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
vagrant@vagrant:/tmp$ type -a bash
bash is /usr/bin/bash
bash is /bin/bash
vagrant@vagrant:/tmp$ mkdir /tmp/new_path_directory/
vagrant@vagrant:/tmp$ cp /bin/bash !$
cp /bin/bash /tmp/new_path_directory/
vagrant@vagrant:/tmp$ PATH=/tmp/new_path_directory/:$PATH
vagrant@vagrant:/tmp$ echo $PATH
/tmp/new_path_directory/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
vagrant@vagrant:/tmp$ type -a bash
bash is /tmp/new_path_directory/bash
bash is /usr/bin/bash
bash is /bin/bash
```

7. Чем отличается планирование команд с помощью batch и at?
at - выполняет команды в указанное время;
batch - выполняет команды, когда нагрузка average падает ниже 1,5 или значения, указанного при вызове atd.