variable "yc_token" {
  default = ""
}

variable "yc_cloud_id" {
  default = ""
}

variable "yc_folder_id" {
  default = ""
}

variable "yc_zone" {
  default = "ru-central1-a"
}

locals {
  vpc_subnets = [
    {
      zone           = "ru-central1-a"
      v4_cidr_blocks = ["10.128.0.0/24"]
    },
    {
      zone           = "ru-central1-b"
      v4_cidr_blocks = ["10.129.0.0/24"]
    },
    {
      zone           = "ru-central1-c"
      v4_cidr_blocks = ["10.130.0.0/24"]
    }
  ]
}