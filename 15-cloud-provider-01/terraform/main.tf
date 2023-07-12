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
      name     = "rootnode01"
      type     = "network-hdd"
      size     = "10"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "node02" {
  name                      = "node02"
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
      name     = "rootnode02"
      type     = "network-hdd"
      size     = "10"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}