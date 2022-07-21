# CI/CD for diploma

1. Заходим в локальный gitlab.  
2. Создаем новый публичный репозиторий.  
3. Копируем любым доступным способом в этот репозиторий файлы из каталога [git-conf](../git-conf)
4. В настройках находим и копируем токен доступа (Settings-CI/CD-Runners), вписываем его в переменную `runner_token` в файле [group_vars/app.yml](./prepare.yml)
5. Для запуска пайплайнов необходимо подготовить машину, развернув на ней gitlab-runner и wp-cli
```bash
$ cd ansible
$ ansible-playbook ../git-conf/prepare.yml -i inventory.yml -l app 
```
