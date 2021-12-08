1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
```
$ git show aefea
    commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
    Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
    Date:   Thu Jun 18 10:29:58 2020 -0400
    Update CHANGELOG.md
```
2. Какому тегу соответствует коммит 85024d3?

`v0.12.23`
4. Сколько родителей у коммита b8d720? Напишите их хеши.

Два родителя.
```
$ git log -1 --pretty=raw b8d720
    commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5
    tree cec002aab630c8bc701cb85bc94e55e751cd2d8f
    parent 56cd7859e05c36c06b56d013b55a252d0bb7e158
    parent 9ea88f22fc6269854151c571162c5bcf958bee2b
```
5. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.
```
$ git log --oneline v0.12.23..v0.12.24
    33ff1c03b (tag: v0.12.24) v0.12.24
    b14b74c49 [Website] vmc provider links
    3f235065b Update CHANGELOG.md
    6ae64e247 registry: Fix panic when server is unreachable
    5c619ca1b website: Remove links to the getting started guide's old location
    06275647e Update CHANGELOG.md
    d5f9411f5 command: Fix bug when using terraform login on Windows
    4b6d06cc5 Update CHANGELOG.md
    dd01a3507 Update CHANGELOG.md
    225466bc3 Cleanup after v0.12.23 release

```
6. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).
```
$ git log -S 'func providerSource'
    commit 8c928e83589d90a031f811fae52a81be7153e82f
    Author: Martin Atkins <mart@degeneration.co.uk>
    Date:   Thu Apr 2 18:04:39 2020 -0700
```
7. Найдите все коммиты в которых была изменена функция globalPluginDirs.
```
$ git log -S 'globalPluginDirs' --oneline
    35a058fb3 main: configure credentials from the CLI config file
    c0b176109 prevent log output during init
    8364383c3 Push plugin discovery down into command package
```
8. Кто автор функции synchronizedWriters?
```
$ git log -S synchronizedWriters
    commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
    Author: Martin Atkins <mart@degeneration.co.uk>
    Date:   Wed May 3 16:25:41 2017 -0700
```