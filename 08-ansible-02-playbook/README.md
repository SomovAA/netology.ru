# Домашнее задание к занятию "2. Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

Изначально я подготовил pycontribs/centos:7 для clickhouse и pycontribs/ubuntu для vector, работаю с ними через ansible_connection: docker.
Для удобной работы сделал [Makefile](Makefile).
Ниже будет описано почему я перешел с pycontribs/ubuntu сперва на pycontribs/centos:8, а далее на pycontribs/centos:7

Для поднятия docker окружения
```
make docker-up
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
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.

На сайте https://vector.dev есть множество способов установки для разных ОС и для разных ПО, я смог найти формат rpm https://packages.timber.io/vector/0.27.0/,
 поэтому сделал подобным образом, как было для clickhouse.

Я думаю процесс установки можно было бы ещё проще сделать, используя rpm напрямую, но тогда это было бы в обход обертки ansible, 
которая под капотом может ещё следить за идемпотентностью, и иметь ещё доп. реализацию.
```
sudo rpm -i https://packages.timber.io/vector/0.27.0/vector-0.27.0-1.{arch}.rpm
```

Я столкнулся с проблемой "Could not detect which major revision of yum is in use, which is required to determine module backend.", 
"You should manually specify use_backend to tell the module whether to use the yum (yum3) or dnf (yum4) backend", т.к. использовал ubuntu, вместо centos, там 
менеджер пакетов apt, а не yum. Следовательно для того, чтобы скрипт одинаково работал для разных ОС нужно некоторые танцы с бубном сделать. 
Какой конткретно подход лучше не знаю. Либо для конкретных ОС придерживаться кокретных настроек play-ов, либо их расширять так, чтобы они одинаково работали для используемых ОС.
Я думал ansible абстрагирован от ОС, используя например доп. расширения/модули, а получается, что установка ПО через ansible все равно зависит от ОС, и некоторого ПО на ней,
 например менеджера пакетов, где-то apt, где-то yum, dnf и т.п..
Поэтому я отказался от pycontribs/ubuntu, и решил использовать pycontribs/centos:8, но там нужно было произвести некоторые действия по добавлению gpk, 
поэтому я решил перейти на pycontribs/centos:7, чтобы не было лишних проблем.

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
```
make ansible-lint
Examining site.yml of type playbook
```
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
```
make ansible-playbook-check

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

TASK [Flush handlers] **********************************************************

TASK [Create database] *********************************************************
skipping: [clickhouse-01]

PLAY [Install Vector] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [vector-01]

TASK [Create a directory] ******************************************************
changed: [vector-01]

TASK [Download] ****************************************************************
ok: [vector-01]

TASK [Install package] *********************************************************
ok: [vector-01]

PLAY RECAP *********************************************************************
clickhouse-01              : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0   
vector-01                  : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```
make ansible-playbook-diff

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

TASK [Flush handlers] **********************************************************

TASK [Create database] *********************************************************
ok: [clickhouse-01]

PLAY [Install Vector] **********************************************************

TASK [Gathering Facts] *********************************************************
ok: [vector-01]

TASK [Create a directory] ******************************************************
changed: [vector-01]

TASK [Download] ****************************************************************
ok: [vector-01]

TASK [Install package] *********************************************************
ok: [vector-01]

PLAY RECAP *********************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

Убедился, но ansible.builtin.file работает порой странно, иногда идемпотентно, иногда вносит изменения
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

Минимум был сделан, но чтобы попрактиковать больше возможностей, я расширил yml файл новыми конструкциями.

Для запуска playbook
```
make ansible-playbook
```

Для запуска с тегом vector
```
make ansible-playbook-tags-vector
```

Вся документация в самом файле с описанием play-ев [site.yml](./playbook/site.yml)
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.
Выложил обычным способом, т.к. эту задачу делали в модуле git. Смысл повторять тоже самое в этом?