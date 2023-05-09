# Домашнее задание к занятию «Хранение в K8s. Часть 1»

### Цель задания

В тестовой среде Kubernetes нужно обеспечить обмен файлами между контейнерам пода и доступ к логам ноды.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке MicroK8S](https://microk8s.io/docs/getting-started).
2. [Описание Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).
3. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

#### Решение

[Deployment](src/Deployment.yml)

```
$ kubectl apply -f ./src/Deployment.yml

$ kubectl get pods
NAME                                 READY   STATUS    RESTARTS   AGE
multitool-busybox-869cbd767d-6cbwq   2/2     Running   0          2m22s

$ kubectl exec -it multitool-busybox-869cbd767d-6cbwq -- cat /input/success.txt
Success!
Success!

$ kubectl exec -it multitool-busybox-869cbd767d-6cbwq -- cat /input/success.txt
Success!
Success!
Success!
Success!
Success!
Success!
```
------

### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.

#### Решение

[Deployment](src/Deployment2.yml)

```
$ kubectl apply -f ./src/Deployment2.yml

$ kubectl get daemonset
NAME        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
multitool   1         1         0       1            0           <none>          6m25s

$ kubectl get pods
NAME              READY   STATUS              RESTARTS   AGE
multitool-59qx6   0/1     ContainerCreating   0          6m46s
```

Логи нет возможности прочитать, т.к. статус ContainerCreating
```
kubectl logs multitool-59qx6
Error from server (BadRequest): container "multitool" in pod "multitool-59qx6" is waiting to start: ContainerCreating
```
Я пробовал создавать отдельно лог файл с доступами 777, все равно под не стартуется...ощущение, что каких-то прав не хватает, 
что нужно запускать контейнеры с особыми правами...нужен совет

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
