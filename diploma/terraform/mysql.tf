resource "yandex_compute_instance" "mysql" {
  count                     = local.workspace["db_count"]
  name                      = "mysql-${terraform.workspace}-0${count.index + 1}"
  zone                      = local.workspace["yandex_zone"]
  hostname                  = "nl-db0${count.index + 1}"
  allow_stopping_for_update = true

  description = "${terraform.workspace} DB node for mysql"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.boot_image.id
      size     = 10
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnetwork.id
    nat        = false
    ip_address = "${local.workspace["subnet_addr"]}.2${count.index + 1}"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
