resource "yandex_compute_instance" "gitlab" {
  name                      = "gitlab-${terraform.workspace}"
  zone                      = local.workspace["yandex_zone"]
  hostname                  = "nl-gitlab"
  allow_stopping_for_update = true

  description = "${terraform.workspace} git node for gitlab"

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
    ip_address = "${local.workspace["subnet_addr"]}.40"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
