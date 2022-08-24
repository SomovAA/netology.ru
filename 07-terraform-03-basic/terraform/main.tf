resource "yandex_compute_image" "image" {
  source_family = var.yc_image
}

resource "yandex_compute_instance" "nodes" {
  count                     = local.instance_count[terraform.workspace]
  name                      = "node-${terraform.workspace}-${count.index}"
  zone                      = var.yc_zone
  allow_stopping_for_update = true

  lifecycle {
    create_before_destroy = true
  }

  resources {
    cores         = local.cores[terraform.workspace]
    memory        = local.memory[terraform.workspace]
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.image.id
      type     = local.disk_type[terraform.workspace]
      size     = local.disk_size[terraform.workspace]
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