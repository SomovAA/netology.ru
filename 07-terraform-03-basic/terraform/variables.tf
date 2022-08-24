variable "yc_token" {
  default = ""
}

variable "yc_cloud_id" {
  default = ""
}

variable "yc_folder_id" {
  default = ""
}

variable "s3_access_key" {
  default = ""
}

variable "s3_secret_key" {
  default = ""
}

variable "yc_zone" {
  default = "ru-central1-a"
}

variable "yc_image" {
  default = "centos-8"
}

locals {
  cores = {
    stage = 2
    prod  = 4
  }
  memory = {
    stage = 2
    prod  = 4
  }
  disk_size = {
    stage = 20
    prod  = 40
  }
  disk_type = {
    stage = "network-hdd"
    prod  = "network-ssd"
  }
  instance_count = {
    stage = 1
    prod  = 2
  }
}