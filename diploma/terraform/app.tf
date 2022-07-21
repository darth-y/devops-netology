resource "yandex_compute_instance" "app" {
  name                      = "wordpress-${terraform.workspace}"
  zone                      = local.workspace["yandex_zone"]
  hostname                  = "nl-app"
  allow_stopping_for_update = true

  description = "${terraform.workspace} app node for wordpress"

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.boot_image.id
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnetwork.id
    nat        = true
    ip_address = "${local.workspace["subnet_addr"]}.30"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
