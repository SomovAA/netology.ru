# Домашнее задание к занятию 14 «Средство визуализации Grafana»

## Задание повышенной сложности

**При решении задания 1** не используйте директорию [help](./help) для сборки проекта. Самостоятельно разверните grafana, где в роли источника данных будет выступать prometheus, а сборщиком данных будет node-exporter:

- grafana;
- prometheus-server;
- prometheus node-exporter.

За дополнительными материалами можете обратиться в официальную документацию grafana и prometheus.

В решении к домашнему заданию также приведите все конфигурации, скрипты, манифесты, которые вы 
использовали в процессе решения задания.

**При решении задания 3** вы должны самостоятельно завести удобный для вас канал нотификации, например, Telegram или email, и отправить туда тестовые события.

В решении приведите скриншоты тестовых событий из каналов нотификаций.

## Обязательные задания

### Задание 1

1. Используя директорию [help](./help) внутри этого домашнего задания, запустите связку prometheus-grafana.
1. Зайдите в веб-интерфейс grafana, используя авторизационные данные, указанные в манифесте docker-compose.
1. Подключите поднятый вами prometheus, как источник данных.
1. Решение домашнего задания — скриншот веб-интерфейса grafana со списком подключенных Datasource.

![grafana](src/1.png)

## Задание 2

Изучите самостоятельно ресурсы:

1. [PromQL tutorial for beginners and humans](https://valyala.medium.com/promql-tutorial-for-beginners-9ab455142085).
1. [Understanding Machine CPU usage](https://www.robustperception.io/understanding-machine-cpu-usage).
1. [Introduction to PromQL, the Prometheus query language](https://grafana.com/blog/2020/02/04/introduction-to-promql-the-prometheus-query-language/).

Создайте Dashboard и в ней создайте Panels:

- утилизация CPU для nodeexporter (в процентах, 100-idle);
```
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[1m])) * 100)
```
- CPULA 1/5/15;
```
avg by (mode, instance) (rate(node_cpu_seconds_total[1m]))
avg by (mode, instance) (rate(node_cpu_seconds_total[5m]))
avg by (mode, instance) (rate(node_cpu_seconds_total[15m]))
```
- количество свободной оперативной памяти;
```
node_memory_MemFree_bytes
```
- количество места на файловой системе.
```
node_filesystem_size_bytes)
```

Для решения этого задания приведите promql-запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

```
Удобно воспользоваться списком доступных метрик у prometheus http://localhost:9090/metrics
Удобно воспользоваться списком доступных метрик у node exporter http://localhost:9100/metrics
```
![grafana](src/2.png)

## Задание 3

1. Создайте для каждой Dashboard подходящее правило alert — можно обратиться к первой лекции в блоке «Мониторинг».
1. В качестве решения задания приведите скриншот вашей итоговой Dashboard.

```
Настроил для телеграм канала, использовал двух ботов телеграма, для получения id по названию канала, и для получение token, при создании бота для работы с каналом.

Т.к. в графане алерты настраиваются только для "графиков", пришлось поменять все типы вывода на тип "график".

Я настроил для двух панелей:
- утилизация CPU для nodeexporter (в процентах, 100-idle) > 80%
- Количество свободной оперативной памяти < 4.2 GB
```

![grafana](src/3.png)

## Задание 4

1. Сохраните ваш Dashboard.Для этого перейдите в настройки Dashboard, выберите в боковом меню «JSON MODEL». Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
1. В качестве решения задания приведите листинг этого файла.

[dashboard.json](src/dashboard.json)