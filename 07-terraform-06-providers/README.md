# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

Бывает, что 
* общедоступная документация по терраформ ресурсам не всегда достоверна,
* в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
* понадобиться использовать провайдер без официальной документации,
* может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.   

## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.   
1. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
    * Какая максимальная длина имени? 
    * Какому регулярному выражению должно подчиняться имя? 

### Решение

Для aws
- resource https://github.com/hashicorp/terraform-provider-aws/blob/v4.28.0/internal/provider/provider.go#L923
- data_source https://github.com/hashicorp/terraform-provider-aws/blob/v4.28.0/internal/provider/provider.go#L414
- ConflictsWith для aws_sqs_queue name https://github.com/hashicorp/terraform-provider-aws/blob/v4.28.0/internal/service/sqs/queue.go#L87
- В версии 4.28 уже нет валидации, ранее она была, использовалась конструкция ValidateFunc

Для yandex-cloud
- resource https://github.com/yandex-cloud/terraform-provider-yandex/blob/v0.77.0/yandex/provider.go#L211
- data_source https://github.com/yandex-cloud/terraform-provider-yandex/blob/v0.77.0/yandex/provider.go#L145
- ConflictsWith для resource_yandex_message_queue name https://github.com/yandex-cloud/terraform-provider-yandex/blob/v0.77.0/yandex/resource_yandex_message_queue.go#L53
- длина не больше 80 и регулярка `^[0-9A-Za-z-_]+(\.fifo)?$` https://github.com/yandex-cloud/terraform-provider-yandex/blob/v0.77.0/yandex/resource_yandex_message_queue.go#L472

## Задача 2. (Не обязательно) 
В рамках вебинара и презентации мы разобрали как создать свой собственный провайдер на примере кофемашины. 
Также вот официальная документация о создании провайдера: 
[https://learn.hashicorp.com/collections/terraform/providers](https://learn.hashicorp.com/collections/terraform/providers).

1. Проделайте все шаги создания провайдера.
2. В виде результата приложение ссылку на исходный код.
3. Попробуйте скомпилировать провайдер, если получится то приложите снимок экрана с командой и результатом компиляции.   
