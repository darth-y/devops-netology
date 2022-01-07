# 3.6. Компьютерные сети, лекция 1
1. Работа c HTTP через телнет.
- Подключитесь утилитой телнет к сайту stackoverflow.com
`telnet stackoverflow.com 80`
- отправьте HTTP запрос
```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
- В ответе укажите полученный HTTP код, что он означает?

Ответ: `HTTP/1.1 301 Moved Permanently`

Что означает - запрошенный документ был окончательно перенесен на новый URI, указанный в поле Location заголовка. Некоторые клиенты некорректно ведут себя при обработке данного кода. Появился в HTTP/1.0. [https://ru.wikipedia.org/](https://ru.wikipedia.org/wiki/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA_%D0%BA%D0%BE%D0%B4%D0%BE%D0%B2_%D1%81%D0%BE%D1%81%D1%82%D0%BE%D1%8F%D0%BD%D0%B8%D1%8F_HTTP#301)

2. Повторите задание 1 в браузере, используя консоль разработчика F12.
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код.
- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?
- приложите скриншот консоли браузера в ответ.

Ответ:

В ответе получен код `200 OK`.

В запросе больше всего заняло установление TLS:

![3.6.2_01](./3.6.2_01.png?raw=true "3.6.2_F12_01")
![3.6.2_02](./3.6.2_02.png?raw=true "3.6.2_F12_02")

3. Какой IP адрес у вас в интернете?

```
vagrant@vagrant:~$ curl ifconfig.co
93.81.207.84
```

4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`

```
vagrant@vagrant:~$ whois $(curl ifconfig.co)
...
route:          93.81.207.0/24
descr:          RU-CORBINA-BROADBAND-POOL10
origin:         AS8402
mnt-by:         RU-CORBINA-MNT
created:        2011-09-26T15:00:05Z
last-modified:  2011-09-26T15:00:05Z
source:         RIPE # Filtered
```

5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`

```
vagrant@vagrant:~$ traceroute -AIn 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  10.0.2.2 [*]  1.337 ms  1.274 ms  1.263 ms
 2  192.168.10.1 [*]  2.794 ms  2.786 ms  2.775 ms
 3  100.129.0.1 [AS21928]  5.645 ms  8.863 ms  8.846 ms
 4  * * *
 5  * * *
 6  * * *
 7  72.14.198.182 [AS15169]  5.724 ms *  5.626 ms
 8  108.170.250.33 [AS15169]  7.261 ms  7.832 ms  8.247 ms
 9  108.170.250.34 [AS15169]  7.815 ms  6.203 ms  6.371 ms
10  142.251.49.24 [AS15169]  20.869 ms  21.303 ms  22.364 ms
11  108.170.235.64 [AS15169]  21.214 ms  22.483 ms  22.473 ms
12  216.239.58.69 [AS15169]  21.993 ms  21.980 ms  19.221 ms
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * 8.8.8.8 [AS15169]  23.740 ms *
```

6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?

```Host                              Loss%   Snt   Last   Avg  Best  Wrst StDev
10. AS15169  142.251.49.24           0.0%    28   21.0  33.2  19.8 132.6  29.7
```

7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`

```
vagrant@vagrant:~$ for NS in $(dig +short +answer NS dns.google); do dig +noall +answer A $NS; done
ns4.zdns.google.     6707       IN      A       216.239.38.114
ns3.zdns.google.     6707       IN      A       216.239.36.114
ns2.zdns.google.     6707       IN      A       216.239.34.114
ns1.zdns.google.     6707       IN      A       216.239.32.114
```

8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`

```
vagrant@vagrant:~$ for PTR in $(for NS in $(dig +short +answer NS dns.google); do dig +short +answer A $NS; done); do dig +noall +answer -x $PTR; done
114.38.239.216.in-addr.arpa. 7171 IN    PTR     ns4.zdns.google.
114.36.239.216.in-addr.arpa. 7171 IN    PTR     ns3.zdns.google.
114.34.239.216.in-addr.arpa. 7171 IN    PTR     ns2.zdns.google.
114.32.239.216.in-addr.arpa. 7171 IN    PTR     ns1.zdns.google.
```