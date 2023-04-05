# Домашнее задание к занятию 12 «GitLab»

## Подготовка к выполнению

1. Подготовьте к работе GitLab [по инструкции](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/gitlab-containers).
2. Создайте свой новый проект.
3. Создайте новый репозиторий в GitLab, наполните его [файлами](./repository).
4. Проект должен быть публичным, остальные настройки по желанию.

## Основная часть

### DevOps

В репозитории содержится код проекта на Python. Проект — RESTful API сервис. Ваша задача — автоматизировать сборку образа с выполнением python-скрипта:

1. Образ собирается на основе [centos:7](https://hub.docker.com/_/centos?tab=tags&page=1&ordering=last_updated).
2. Python версии не ниже 3.7.
3. Установлены зависимости: `flask` `flask-jsonpify` `flask-restful`.
4. Создана директория `/python_api`.
5. Скрипт из репозитория размещён в /python_api.
6. Точка вызова: запуск скрипта.
7. Если сборка происходит на ветке `master`: должен подняться pod kubernetes на основе образа `python-api`, иначе этот шаг нужно пропустить.

### Product Owner

Вашему проекту нужна бизнесовая доработка: нужно поменять JSON ответа на вызов метода GET `/rest/api/get_info`, необходимо создать Issue в котором указать:

1. Какой метод необходимо исправить.
2. Текст с `{ "message": "Already started" }` на `{ "message": "Running"}`.
3. Issue поставить label: feature.

### Developer

Пришёл новый Issue на доработку, вам нужно:

1. Создать отдельную ветку, связанную с этим Issue.
2. Внести изменения по тексту из задания.
3. Подготовить Merge Request, влить необходимые изменения в `master`, проверить, что сборка прошла успешно.


### Tester

Разработчики выполнили новый Issue, необходимо проверить валидность изменений:

1. Поднять докер-контейнер с образом `python-api:latest` и проверить возврат метода на корректность.
2. Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый.

## Итог

В качестве ответа пришлите подробные скриншоты по каждому пункту задания:

- файл gitlab-ci.yml;
- Dockerfile; 
- лог успешного выполнения пайплайна;
- решённый Issue.

### Важно 
После выполнения задания выключите и удалите все задействованные ресурсы в Yandex Cloud.

## Необязательная часть

Автомазируйте работу тестировщика — пусть у вас будет отдельный конвейер, который автоматически поднимает контейнер и выполняет проверку, например, при помощи curl. На основе вывода будет приниматься решение об успешности прохождения тестирования.

---

### Решение

Сперва пытался развернуть инфраструктуру локально через докер, но из-за проблем с сертификатами, регистрация агента не проходит, 
проблему решить не смог. [docker-compose.yml](docker-compose.yml)

Далее воспользовался официальным сайтом gitlab, т.к. кубик мы не проходили, не стал делать через него.

Сссылка на проект https://gitlab.com/somovAA/netology/, в нем можно найти всё необходимое.
Проблему с версией не ниже 3.7 решить не смог, т.к. для этого требуется openssl обновить до версии 1.1, 
но также ряд других нюансов учесть...В остальном всё сделано, и работает корректно.

Результат тестировщиков
```
docker pull registry.gitlab.com/somovaa/netology/python-api.py:latest
latest: Pulling from somovaa/netology/python-api.py

2d473b07cdd5: Already exists 
bd6fc80d3432: Pulling fs layer 
57542a15eb33: Pulling fs layer 
871f5d5eae54: Pulling fs layer 
Digest: sha256:c7d9c82f4906bee51cb8c9df61efd8ed22ee6a2139b60a27245ec969b02b7ead
Status: Downloaded newer image for registry.gitlab.com/somovaa/netology/python-api.py:latest
registry.gitlab.com/somovaa/netology/python-api.py:latest

docker run -p 5290:5290 -d registry.gitlab.com/somovaa/netology/python-api.py:latest
5de0b2afccb507f4b6d7b083febc31071ca9bd5b59900b6c0353f49e2791a276

curl localhost:5290/get_info
{"version": 3, "method": "GET", "message": "Running"}
```