# Домашнее задание к занятию "5.1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения."

## Задача 1

Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.

- полная (аппаратной) виртуализация - гипервизоры устанавливаются на голое железо, им не требуется ОС, т.к. в них она есть, ключевая особенность - полное использование апаратных ресурсов хоста;
- паравиртуализации - гипервизор устанавливается поверх ОС, которая определяет доступ к ресурсам хоста, он с ней делит ресурсы, модифицируя ядро гостевой ОС. Гипервизор ограничивает использование ресурсов VM;
- виртуализации на основе ОС - выбор гипервизора зависит от типа ядра ОС, разделение ресурсов осуществляется на уровне ОС. ВМ изолированы друг от друга, но не возможно запускать ОС с ядрами, отличными от типа ядра базовой операционной системы. Можно устанавливать собственные патчи на ядро. Контейнеры могут работать со всеми ресурсами хостовой машины. Т.к. они зависят от ядра, то могут использовать общие динамические библиотеки, страницы памяти и т.п., в целом это экономит ресурсы, и позволяет быстро работать с контейнерами.

## Задача 2

Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.

Организация серверов:
- физические сервера,
- паравиртуализация,
- виртуализация уровня ОС.

Условия использования:
- Высоконагруженная база данных, чувствительная к отказу.
- Различные web-приложения.
- Windows системы для использования бухгалтерским отделом.
- Системы, выполняющие высокопроизводительные расчеты на GPU.

Опишите, почему вы выбрали к каждому целевому использованию такую организацию.

- Высоконагруженная база данных, чувствительная к отказу - физический сервер, т.к. чем меньше слоев, тем лучше для производительности, также точек отказа меньше. Если бы речь шла ещё и о доступности, то нужна была бы кластеризация, нужно было бы использовать не один физический сервер, можно тогда и полную аппаратную виртуализацию.
- Различные web-приложения - виртуализация уровня ОС, т.к. администрировать проще, хотя есть свои нюансы по готовке контейнеров (12 факторов, каждая очередь, как отдельный контейнер и прочее...). Удобно масштабировать, производить бесшовные деплои, нет жестких требований к аппаратнымм ресурсам.
- Windows системы для использования Бухгалтерским отделом - паравиртуализация, т.к. эффективнее делать бэкапы, возможность расширять ресурсы на уровне вирт. машины. В некоторых случаях можно и через контейнеризацию пойти.
- Системы, выполняющие высокопроизводительные расчеты на GPU - физические сервера, т.к. чем меньше слоев, тем быстрее, также и меньше ресурсов будет использоваться на лишнее. Максимально быстрый доступ к аппаратным ресурсам.

## Задача 3

Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.
   1. VMWare. Кластеризация и отказоустойчивость. Высокий уровень безопасности. Компоненты: планировщик ресурсов, распределенная файловая система, сетевой стек, стек хранения данных.
2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.
   1. Xen. Гостевые машины в режиме Xen PV обычно основаны на шаблонахдля быстрого развертывания и высокой производительности. Подходит для Linux и Windows.
3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.
   1. Hyper-V. Является выбором defacto для окружений с преобладанием технологий Microsoft. Низкий порог вхождения для инженеров. Содержит компоненты: миграция виртуальных машин, реплики, файловые системы, миграция накопителей данных
4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.
   1. KVM. Нативный для Linux, низкий порог входа, каждая гостевая машина работает, как процесс на хостовой машине, что хорошо для обнаружения источника проблемы.

## Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.

Зависит от ситуации:
- возможно мы уже попали в такое место, где это используется;
- возможно гипервизор был бесплатен некоторое время, а затем стал платным или наоборот, поддержка и развитие его остановилось, и мы приняли решение оставаться на бесплатной старой версии, и постепенно с неё переходить, а новые проекты разворачивать, используя другой гипервизор;
- маловероятно, но возможно для одних проектов нужен гипервизор с одним функционалом, а для других другой с другим, отсюда может начаться путь с зоопарком;
- возможно нет специалистов нужных на рынке, чтобы новые проекты разворачивать, используя конкретный гипервизор, который уже используется для других проектов. И приходится подстраиваться под то, что есть.
- маловероятно, но может быть есть переход с одного гипервизора на третий, используя второй. От простого к сложному. Не всегда легко перейти с чего-то простого, сразу на самое сложное, порой проще сделать несколько итераций.
- возможно используется один гипервизор, но разных версий для разных проектов. И эти версии могут настолько друг от друга отличаться, что это можно назвать разными гипервизорами, т.к. проблемы могут быть схожими, хоть и не полностью, если использовать действительно разные.

Я бы старался использовать принцип 'разделяй и властвуй'.
Чтобы не было ситуаций, когда на одной машине используется сразу несколько... Например, на linux Virtualox(vagrant) + docker. 
Либо в одной VM есть другая VM и т.п... Т.е. не должно быть вложенностей, кучи иначе это невыносимо контролировать.
Пусть кучи и будут, но хотя бы сгруппированные и изолированные друг от друга, а не вперемешку и с вложенностями.
Иначе никогда не будет ощущения покоя, т.к. в одном месте поменял, а стрельнуть может в другом из-за конкуренции в ресурсах, доступов, и прочем...
Также чем больше слоев, тем медленнее это работает, тем больше мест нестандартных, с которыми нужно понимать, как работать.
Такое тестировать невозможно или очень сложно. Требуется одновременное знание множества технологий, таких людей найти сложно.
Нужно сокращать зоопарк технологий.

Если мы уже в такой ситуации, то лучше заниматься только поддержкой, ничего не добавляя, не обновляя...
И постепенно этот узел развязывать, и переносить частями по возможности. Желательно покрывая перед этим всё тестами максимально.

Представить сложно, как можно перенести без ошибок проект с одного деплой стека на другой.
Возникающие подводные камни вряд ли можно найти заранее, скорей всего придется наступать самому на эти грабли.

В плане безопасности, мб и можно это интересным образом использовать. Многоуровневая защита, взломали один слой, а у тебя там их ещё 10...пока доберутся до последнего, ты уже всё поймешь, и сервер сожжешь.

Если бы можно было бы создать свой слой со своими интерфейсами, куда подсовывать реализацию, выбирая и заменяя гипервизоры, чтобы 
ничего не изменять в деплоях и т.п. моментах, то было бы здорово, но, как я понял, такого не существует в мире, в отличие от языков программирования, где это спасает от множества бед, 
и не требует менять в проекте множество мест, а требует лишь новую реализацию написать под интерфейс, тесты на неё, и сказать приложению, чтобы он её подсовывал, это делается всего лишь в одном месте :)

