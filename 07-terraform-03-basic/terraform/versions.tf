terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.61.0"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "netology-test"
    region     = "ru-central1"
    key        = "terraform.tfstate"
#    access_key = var.s3_access_key
#    secret_key = var.s3_secret_key

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}