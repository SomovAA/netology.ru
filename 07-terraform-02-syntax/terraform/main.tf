resource "yandex_compute_image" "image" {
  source_family = var.yc_image
}

resource "yandex_compute_instance" "node01" {
  name                      = "node01"
  zone                      = var.yc_zone
  allow_stopping_for_update = true

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.image.id
      name     = "root"
      type     = "network-hdd"
      size     = "50"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
    nat       = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}