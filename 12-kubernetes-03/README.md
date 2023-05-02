# Домашнее задание к занятию «Запуск приложений в K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Deployment с приложением, состоящим из нескольких контейнеров, и масштабировать его.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) Init-контейнеров.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к репликам приложения из другого Pod

1. Создать Deployment приложения, состоящего из двух контейнеров — nginx и multitool. Решить возникшую ошибку.
2. После запуска увеличить количество реплик работающего приложения до 2.
3. Продемонстрировать количество подов до и после масштабирования.
4. Создать Service, который обеспечит доступ до реплик приложений из п.1.
5. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложений из п.1.

#### Решение
Ошибка была в запуске двух контейнеров с одинаковыми портами 80, в документации multitool написано, как сменить порты на лету через env.

[Deployment](src/deployment1.yml)

```
$ kubectl apply -f ./src/deployment1.yml

$ kubectl get deployments
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
nginx-multitool   2/2     2            2           22m

$ kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
nginx-multitool-5786c6888f-5dgxf   2/2     Running   0          4m10s

$ kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
nginx-multitool-5786c6888f-5dgxf   2/2     Running   0          4m30s
nginx-multitool-5786c6888f-ntffm   2/2     Running   0          10s
```

[Service](src/service1.yml)

Чтобы проверить работу сервиса, запускал ручками port-forward
```
$ kubectl apply -f ./src/service1.yml

$ kubectl get service
NAME           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)           AGE
kubernetes     ClusterIP   10.96.0.1      <none>        443/TCP           5d18h
netology-svc   ClusterIP   10.99.10.154   <none>        80/TCP,1180/TCP   21m

$ kubectl port-forward svc/netology-svc 36307:80

$ kubectl port-forward svc/netology-svc 37307:1180

В браузере по ссылке localhost:37307 видим
WBITT Network MultiTool (with NGINX) - nginx-multitool-5d6f4d4f8-8ttfc - 10.244.0.24 - HTTP: 1180 , HTTPS: 443 . (Formerly praqma/network-multitool)

```

[Pod](src/pod1.yml)

```
$ kubectl apply -f ./src/pod1.yml

$ kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
netology-web                      1/1     Running   0          5m17s
nginx-multitool-5d6f4d4f8-8ttfc   2/2     Running   0          19m
nginx-multitool-5d6f4d4f8-gtstz   2/2     Running   0          19m

$ kubectl exec -it netology-web -- curl netology-svc:80
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
...

$ kubectl exec -it netology-web -- curl netology-svc:1180
WBITT Network MultiTool (with NGINX) - nginx-multitool-5d6f4d4f8-gtstz - 10.244.0.25 - HTTP: 1180 , HTTPS: 443 . (Formerly praqma/network-multitool)
```

------

### Задание 2. Создать Deployment и обеспечить старт основного контейнера при выполнении условий

1. Создать Deployment приложения nginx и обеспечить старт контейнера только после того, как будет запущен сервис этого приложения.
2. Убедиться, что nginx не стартует. В качестве Init-контейнера взять busybox.
3. Создать и запустить Service. Убедиться, что Init запустился.
4. Продемонстрировать состояние пода до и после запуска сервиса.


#### Решение

[Deployment](src/deployment2.yml)

```
$ kubectl apply -f ./src/deployment2.yml

$ kubectl get pods
NAME                             READY   STATUS     RESTARTS   AGE
nginx-busybox-9f47b88b9-t977v   0/1     Init:0/1   0          4s
```

[Service](src/service2.yml)

```
$ kubectl apply -f ./src/service2.yml

$ kubectl get pods
NAME                             READY   STATUS     RESTARTS   AGE
nginx-busybox-9f47b88b9-t977v   0/1     Init:0/1   0          47s
```

НУЖНА подсказка! Для init containers Probes не работают. Как проверять наличие сервиса, которого не существует, и где это делать?
Почему-то через curl не работает, даже если сервис стартануть сразу. Какую последовательность шагов сделать?
------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------
