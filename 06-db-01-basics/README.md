# Домашнее задание к занятию "6.1. Типы и структура СУБД"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Архитектор ПО решил проконсультироваться у вас, какой тип БД 
лучше выбрать для хранения определенных данных.

Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:

- Электронные чеки в json виде

Документо-ориентированная, каждый документ представляет отдельные данные;
- Склады и автомобильные дороги для логистической компании

Больше одного родителя - сетевая (паутина) и графовая (узлы, ребра);
- Генеалогические деревья

Иерархическая - древовидная;
- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации

Ключ-значение - удобно хранить сессии и другиие виды кэша любых значений, если сессия пропадет, то клиент просто перезайдет, 
доступ обычно у таких систем мгновенный, т.к. в ОП хранят данные.
- Отношения клиент-покупка для интернет-магазина

Реляционная - важна связь между данными и структура данных должна быть согласована, важен ACID.

Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.

## Задача 2

Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно 
CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если 
(каждый пункт - это отдельная реализация вашей системы и для каждого пункта надо привести классификацию):

- Данные записываются на все узлы с задержкой до часа (асинхронная запись)

Если мы ждем ответа около часа, пока все узлы не синхронизируются, то это CA, т.к. на всех узлах будет одинаково, а успешный ответ, ожидаемый около часа, считается доступным. EL-PC.

Если мы получаем ответы без синхронизации сразу же, получается они могут быть разными на узлах. Тогда это AP. PA-EL.
- При сетевых сбоях, система может разделиться на 2 раздельных кластера

Т.к. 2 кластера будут жить отдельной жизнью некоторое время, без синхронизаций, значит C мы не можем гарантировать.

Т.к. есть доступность и разделение, то это AP.
PA-EL.
- Система может не прислать корректный ответ или сбросить соединение

Т.е. система не всегда доступна, не можем гарантировать A, значит CP. PC-EL.


А согласно PACELC-теореме, как бы вы классифицировали данные реализации?

## Задача 3

Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?

Сравниваются высоконадежные системы с высокопроизводительными. 
Если учитывать конечный результат для пользователей, то сочетание невозможно, т.к. их 
свойства противоречивы. В ACID данные всегда корректны, в BASE нет.

## Задача 4

Вам дали задачу написать системное решение, основой которого бы послужили:

- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута

Вы слышали о key-value хранилище, которое имеет механизм [Pub/Sub](https://habr.com/ru/post/278237/). 
Что это за система? Какие минусы выбора данной системы?

Это Redis.

Минусы:
- т.к. это NoSQL система, следовательно нет возможности элегантного поиска, используя SQL.
- в редисе можно настроить аутентификацию по паролю, но на этом и всё, т.е. контроля доступа, как в реляционных БД, нет.
- т.к. редис в основном использует ОП, а не жесткий диск, следовательно нужно следить за этим.
- если редис использовать как полноценую Pub/Sub систему, то гарантировать 100% доставку невозможно, для этого лучше выбирать rabbitMQ или kafka, т.к. в редисе нет полноценной реализации для решения подобных проблем.
- не стоит использовать, как замену реляционным БД, по ряду проблем с безопасностью (не поддерживает шифрование...), с хранением данных...