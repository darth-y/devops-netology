resource "yandex_compute_instance" "proxy" {
  name                      = "proxy-${terraform.workspace}"
  zone                      = local.workspace["yandex_zone"]
  hostname                  = var.domain
  allow_stopping_for_update = true

  description = "${terraform.workspace} nginx node for reverse-proxy"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.boot_image.id
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnetwork.id
    nat        = true
    ip_address = "${local.workspace["subnet_addr"]}.10"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "external_ip_address_nginx" {
  value = yandex_compute_instance.proxy.network_interface.0.nat_ip_address
}