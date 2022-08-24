# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 


## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  
1. Создайте два воркспейса `stage` и `prod`.
1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
1. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
```
terraform workspace list
  default
* prod
  stage
```
* Вывод команды `terraform plan` для воркспейса `prod`.  
```
terraform plan
yandex_vpc_network.default: Refreshing state... [id=enp9quvudi9v8q6kq5ln]
yandex_compute_image.image: Refreshing state... [id=fd8ml416f5g0mpu4lhjh]
yandex_vpc_subnet.default: Refreshing state... [id=e9bsti881uhvgtas5f0k]
yandex_compute_instance.nodes[0]: Refreshing state... [id=fhm4isno5pbdtoiria63]
yandex_compute_instance.nodes[1]: Refreshing state... [id=fhm827su38cfl8sa8vch]

Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the last "terraform apply" which may have affected this plan:

  # yandex_compute_instance.nodes[0] has been deleted
  - resource "yandex_compute_instance" "nodes" {
        id                        = "fhm4isno5pbdtoiria63"
        name                      = "node-prod-0"
        # (5 unchanged attributes hidden)

      ~ network_interface {
            # (6 unchanged attributes hidden)
        }

        # (2 unchanged blocks hidden)
    }


Unless you have made equivalent changes to your configuration, or ignored the relevant attributes using ignore_changes, the following plan may include actions to undo or respond to these changes.



Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.nodes[0] will be created
  + resource "yandex_compute_instance" "nodes" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3N5AMDkrrOjsPYAJEFwwkZMXq0tgxWVnezts/guCwzlp6BReB5qDMkoczt1nRHVtPlJc6lMcplzBLhen5xBUsueAlhtm6B/SZ1KnbKFEctdGY+kR9zGAYwgNxidxUZYlTEwUzKK4b9Mryjif1v+0W/9L7WnjKyAp7ySOWKfzRpxyHFZUAb/XnmXzO0BaScma6XJZS4ulCVf/dWY4hwtD1VxM8xjJV4OtkDqgLtjC/PwKA8kHccnPG2XzlyqWAuXHcTipaOi10QBAX0kqbvPppfzIpBCQt4c/f6fsyCTqIpOieo7uqIxBlGqgwTRcomd1Ct6zmg6iRzfupfgv5xklz a.somov@robo.cash
            EOT
        }
      + name                      = "node-prod-0"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + description = (known after apply)
              + image_id    = "fd8ml416f5g0mpu4lhjh"
              + name        = (known after apply)
              + size        = 40
              + snapshot_id = (known after apply)
              + type        = "network-ssd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = "e9bsti881uhvgtas5f0k"
        }

      + placement_policy {
          + placement_group_id = (known after apply)
        }

      + resources {
          + core_fraction = 20
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_nodes_yandex_cloud = (known after apply)
  + internal_ip_address_nodes_yandex_cloud = (known after apply)



Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

Инструкция:
1. Выполните команду, и установите необходимые параметры в .env файле
```
make copy-env-file
```
2. Создайте необходимый workspace
```
make workspace-new
```
3. Запустите деплой
```
make all
```

#### P.S. 

Пришлось ковыряться с возможностями передавать параметры извне в terraform: 
ENVS, TF_VAR_, workspace, -backend-config...
почему через единый вариант не сделать не понимаю, 
логика определенная есть, но её можно было бы добиться 
и используя один вариант. 
Пришлось разные в разных случаях использовать, это боль.

Также создание бакета есть через terraform или ручками, но проблема в том, 
что это нельзя сделать полностью автоматически, т.е. отдельными конфигами он создается, а затем используется в других конфигах, 
с установленными ключами доступа...тоже боль.