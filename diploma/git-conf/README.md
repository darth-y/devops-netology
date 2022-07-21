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
Для демонстрации CI/CD на Wordpress изменим главную тему. Сейчас при наведении курсора на ссылку она подчеркивается пунктиром:
  
![](/screenshots/cicd1.png)  

Изменим файл `wp-content/themes/mytheme/style.css`. Поменяем `text-decoration-style` на `waved`
  
![](/screenshots/cicd2.png)  
  
После коммита ждем отработки задачи
  
![](/screenshots/cicd3.png)  
  
Обновляем страницу и видим, что ссылка стала подчеркиваться волнистой линией.
  
![](/screenshots/cicd4.png)
  
Описание действий, которые делает раннер, в комментариях в файле `.gitlab-ci.yml`
