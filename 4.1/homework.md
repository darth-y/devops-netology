# 4.1. Командная оболочка Bash: Практические навыки

## Обязательная задача 1

Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная  | Значение | Обоснование |
| ------------- | ------------- | ------------- |
| `c`  | a+b  | Переменной c присвоено значение строки после = |
| `d`  | 1+2  | Переменной d присвоено значение переменных a и b, а между ними + |
| `e`  | 3  | Переменной e присвоена сумма переменных a и b |


## Обязательная задача 2
На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
```bash
#!/usr/bin/env bash
while ((1==1))
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	else
		echo Cool done!
		break
	fi
done
exit 0
```

Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт:
```bash
#!/usr/bin/env bash
ips=(192.168.0.1 173.194.222.113 87.250.250.242)
port=80
count=5
c=0
log_file=./ping.log
date > $log_file

while (($c < $count))
do
        for ip in ${ips[@]}
        do
                curl --connect-timeout 1 ${ip}:${port}
                echo Check $ip result: $? >> $log_file
        done
        let "c+=1"
done
echo === DONE ===
echo Checkout log file: cat $log_file
exit 0
```

## Обязательная задача 3
Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:
```bash
#!/usr/bin/env bash
ips=(173.194.222.113 192.168.0.1 87.250.250.242)
port=80
err_file=./ping-error.log
date > $err_file

while ((1==1))
do
        for ip in ${ips[@]}
        do
                curl --connect-timeout 1 ${ip}:${port}
                exit_code=$?
                if [ $exit_code -ne 0 ]
                then
                        echo Check $ip failed with error code: $exit_code >> $err_file
                        echo === DONE ===
                        echo Checkout log file: cat $err_file
                        exit 0
                fi
        done
done
exit 0
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Мы хотим, чтобы у нас были красивые сообщения для коммитов в репозиторий. Для этого нужно написать локальный хук для git, который будет проверять, что сообщение в коммите содержит код текущего задания в квадратных скобках и количество символов в сообщении не превышает 30. Пример сообщения: \[04-script-01-bash\] сломал хук.

### Ваш скрипт:
```bash
???
```