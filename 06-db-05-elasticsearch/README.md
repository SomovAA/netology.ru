# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [elasticsearch:7](https://hub.docker.com/_/elasticsearch) как базовый:

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения
- обратите внимание на настройки безопасности такие как `xpack.security.enabled`
- если докер образ не запускается и падает с ошибкой 137 в этом случае может помочь настройка `-e ES_HEAP_SIZE`
- при настройке `path` возможно потребуется настройка прав доступа на директорию

Далее мы будем работать с данным экземпляром elasticsearch.

[elasticsearch.yml](docker/elasticsearch/elasticsearch.yml).

[Dockerfile](docker/elasticsearch/Dockerfile).

[docker-compose.yml](docker-compose.yml).

Для сборки, исользуя dockerfile
```
docker-compose build
```

Для отправки в репо
```
docker-compose push
```

Для подтягивания из репо
```
docker-compose pull
```

Для запуска
```
docker-compose up -d
```

Ссылка на образ https://hub.docker.com/r/hitenok/elasticsearch_netology

Заходим в контейнер, и делаем запрос
```
docker exec -it elasticsearch bash

curl http://localhost:9200
{
  "name" : "netology_test",
  "cluster_name" : "cluster_netology_test",
  "cluster_uuid" : "y_zTIuR7Tbebe3aDZ3MSAw",
  "version" : {
    "number" : "7.17.5",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "8d61b4f7ddf931f219e3745f295ed2bbc50c8e84",
    "build_date" : "2022-06-23T21:57:28.736740635Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}

Опцию xpack.security.enabled не стал выставлять в true, тогда нужно было бы создать доп. пользователей, нам и без этого хватит и без сертификатов.
Все настройки для elastica можно было бы выставить динамически через передачу env в контейнер, но можно и через файлы. 
Я сделал двумя способами. Для JVM я увеличил ресурсы через env "ES_JAVA_OPTS=-Xms1g -Xmx1g", вместо ES_HEAP_SIZE в файле jvm.options.
```

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html)
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

Создадим индексы
```
curl -X PUT http://localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 0,  "number_of_shards": 1 }}'
curl -X PUT http://localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 1,  "number_of_shards": 2 }}'
curl -X PUT http://localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 2,  "number_of_shards": 4 }}' 
```

Выведем индексы
```
curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases jBk4lCapSri6ewDRksemOQ   1   0         40            0     37.9mb         37.9mb
green  open   ind-1            bNM43ZajTxqmrsaT_1uayw   1   0          0            0       226b           226b
yellow open   ind-3            0iICZMPETFaOXem6j0hfyQ   4   2          0            0       904b           904b
yellow open   ind-2            u5dzRMKrTq6I0R6mnIsjXw   2   1          0            0       452b           452b
```

Расширенная информация о индексах
```
curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "cluster_netology_test",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}

curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "cluster_netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}

curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "cluster_netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```

Информация о кластере
```
curl -X GET 'http://localhost:9200/_cluster/health/?pretty'
{
  "cluster_name" : "cluster_netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```

Удалим индексы
```
curl -X DELETE 'http://localhost:9200/ind-1'
curl -X DELETE 'http://localhost:9200/ind-2'
curl -X DELETE 'http://localhost:9200/ind-3'
```

Если реплики указаны, а узел один, тогда yellow, т.к. условие не выполняется.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository)
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html)
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее.

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

```
curl -X POST http://localhost:9200/_snapshot/netology_backup -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/var/lib/elasticsearch/snapshots" }}'
{"acknowledged":true}

curl -X PUT http://localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 0, "number_of_shards": 1 }}'

curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases jBk4lCapSri6ewDRksemOQ   1   0         40            0     37.9mb         37.9mb
green  open   test             yPIgRlrNTSiKmWBXi0dWKA   1   0          0            0       226b           226b


curl -X PUT http://localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true

ls -l /var/lib/elasticsearch/snapshots
-rw-rw-r-- 1 elasticsearch root   847 Aug 13 01:35 index-0
-rw-rw-r-- 1 elasticsearch root     8 Aug 13 01:35 index.latest
drwxrwxr-x 4 elasticsearch root  4096 Aug 13 01:35 indices
-rw-rw-r-- 1 elasticsearch root 28779 Aug 13 01:35 meta-D7r4du94RkuxUl4dyzDqYg.dat
-rw-rw-r-- 1 elasticsearch root   440 Aug 13 01:35 snap-D7r4du94RkuxUl4dyzDqYg.dat


curl -X DELETE 'http://localhost:9200/test'
curl -X PUT http://localhost:9200/test2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 0, "number_of_shards": 1 }}'

curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases jBk4lCapSri6ewDRksemOQ   1   0         40            0     37.9mb         37.9mb
green  open   test2            hHfrJ3qmQ5ipF0s5S9NL8g   1   0          0            0       226b           226b

curl -X POST http://localhost:9200/_snapshot/netology_backup/elasticsearch/_restore -H 'Content-Type: application/json' -d'{"include_global_state":true}'

curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases uZzW8r9nSWyRHCM4BTvk4g   1   0         40            0     37.9mb         37.9mb
green  open   test2            hHfrJ3qmQ5ipF0s5S9NL8g   1   0          0            0       226b           226b
green  open   test             jcj4VfujT9-_ZNjheIvXiw   1   0          0            0       226b           226b
```