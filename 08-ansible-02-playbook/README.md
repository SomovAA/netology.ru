# Домашнее задание к занятию "2. Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

Хосты поднял, используя docker.

Для удобной работы сделал [Makefile](Makefile).

Для поднятия хостов
```
make docker-up
```

```
playbook$ docker ps
CONTAINER ID   IMAGE                 COMMAND            CREATED          STATUS          PORTS     NAMES
224f181e4782   pycontribs/centos:7   "/usr/sbin/init"   36 seconds ago   Up 35 seconds             vector-01
3f6389a121cf   pycontribs/centos:7   "/usr/sbin/init"   36 seconds ago   Up 35 seconds             clickhouse-01
```

Для остановки
```
make docker-down
```

Для остановки, и очистки volumes
```
make docker-down-clear
```

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.

Дописал в преддложенном файле для домашки inventory для vector [prod.yml](./playbook/inventory/prod.yml), для clickhouse изменил с `ansible_host: <IP_here>` на `ansible_connection: docker`.

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).

Дописал в предложенном файле для домашки play для vector [site.yml](./playbook/site.yml), play для clickhouse изменил, т.к. он был нерабочим вариантом.

3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.

Модуль `unarchive` не пригодился, т.к. для установки использую rpm.

4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.

Создаю директорию, скачиваю rpm нужной версии в директорию, устанавливаю, перезапускаю службу. 
Шаблоны для конфига и службы по умолчанию есть, свои вставлять в этой задаче не требуется.

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```
make ansible-lint
Examining site.yml of type playbook
```
Ошибок нет.

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
```
make ansible-playbook-check

PLAY [Install Vector] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [vector-01]

TASK [Create a directory] ******************************************************
ok: [vector-01]

TASK [Download] ****************************************************************
ok: [vector-01]

TASK [Install package] *********************************************************
changed: [vector-01]

TASK [Start vector service] ****************************************************
fatal: [vector-01]: FAILED! => {"changed": false, "msg": "Could not find the requested service vector: host"}
...ignoring

PLAY [Install Clickhouse] ******************************************************

TASK [Gathering Facts] *********************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *********************************************
changed: [clickhouse-01]

TASK [Start clickhouse service] ************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "Could not find the requested service clickhouse-server: host"}
...ignoring

TASK [Create database] *********************************************************
skipping: [clickhouse-01]

PLAY RECAP *********************************************************************
clickhouse-01              : ok=4    changed=1    unreachable=0    failed=0    skipped=1    rescued=1    ignored=1   
vector-01                  : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=1   
```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```
make ansible-playbook-diff

PLAY [Install Vector] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [vector-01]

TASK [Create a directory] ******************************************************
ok: [vector-01]

TASK [Download] ****************************************************************
ok: [vector-01]

TASK [Install package] *********************************************************
changed: [vector-01]

TASK [Start vector service] ****************************************************
changed: [vector-01]

PLAY [Install Clickhouse] ******************************************************

TASK [Gathering Facts] *********************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *********************************************
changed: [clickhouse-01]

TASK [Start clickhouse service] ************************************************
changed: [clickhouse-01]

TASK [Create database] *********************************************************
changed: [clickhouse-01]

PLAY RECAP *********************************************************************
clickhouse-01              : ok=5    changed=3    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=5    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
```
make ansible-playbook-diff

PLAY [Install Vector] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [vector-01]

TASK [Create a directory] ******************************************************
ok: [vector-01]

TASK [Download] ****************************************************************
ok: [vector-01]

TASK [Install package] *********************************************************
ok: [vector-01]

TASK [Start vector service] ****************************************************
ok: [vector-01]

PLAY [Install Clickhouse] ******************************************************

TASK [Gathering Facts] *********************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] **************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] *********************************************
ok: [clickhouse-01]

TASK [Start clickhouse service] ************************************************
ok: [clickhouse-01]

TASK [Create database] *********************************************************
ok: [clickhouse-01]

PLAY RECAP *********************************************************************
clickhouse-01              : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```
Убедился.

9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

Для запуска playbook
```
make ansible-playbook
```

Для запуска с тегом vector
```
make ansible-playbook-tags-vector
```

Playbook [site.yml](./playbook/site.yml)

Для проверки успешной установки можно воспользоваться командами

```
make docker-exec-vector-01-status-service

vector.service - Vector
   Loaded: loaded (/usr/lib/systemd/system/vector.service; disabled; vendor preset: disabled)
   Active: active (running) since Sun 2023-02-19 19:21:02 UTC; 24min ago
     Docs: https://vector.dev
 Main PID: 1410 (vector)
   CGroup: /docker/599b1004ef08e5ab7eda326f13abb71a67c136dedb539ff69a4f415fdf9db000/system.slice/vector.service
           └─1410 /usr/bin/vector
           ‣ 1410 /usr/bin/vector
```

```
make docker-exec-clickhouse-01-check-service

clickhouse-server.service - ClickHouse Server (analytic DBMS for big data)
   Loaded: loaded (/usr/lib/systemd/system/clickhouse-server.service; disabled; vendor preset: disabled)
   Active: active (running) since Sun 2023-02-19 19:21:27 UTC; 23min ago
 Main PID: 1800 (clckhouse-watch)
   CGroup: /docker/fc2664e1ec4f861bef820b1ed21ef32fb5351f539d8132f4337b5519442bb658/system.slice/clickhouse-server.service
           ├─1800 clickhouse-watchdog --config=/etc/clickhouse-server/config....
           └─1802 /usr/bin/clickhouse-server --config=/etc/clickhouse-server/...
           ‣ 1800 clickhouse-watchdog --config=/etc/clickhouse-server/config....
```

```
make docker-exec-clickhouse-client-check

ClickHouse client version 22.3.3.44 (official build).
Connecting to 127.0.0.1:9000 as user default.
Connected to ClickHouse server version 22.3.3 revision 54455.

fc2664e1ec4f :) 
```

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.




#### GROUP VARS

clickhouse_version - версия clickhouse
clickhouse_packages - список пакетов clickhouse
vector_arch - архитектура для версии vector
vector_dir - директория для файла rpm vector

#### Описание Play

Установка и настройка vector и clickhouse на хостах

#### Install Vector

Определен тег vector

- установка переменных (facts)
- создание директории для установочного файла
- загрузка установочного файла
- установка пакета
- старт сервиса

#### Install Clickhouse

Определен тег clickhouse

- загрузка установочных пакетов
- установка пакетов
- старт сервиса
- создание БД