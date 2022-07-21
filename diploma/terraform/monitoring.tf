resource "yandex_compute_instance" "monitoring" {
  name                      = "monitoring-${terraform.workspace}"
  zone                      = local.workspace["yandex_zone"]
  hostname                  = "nl-monitoring"
  allow_stopping_for_update = true

  description = "${terraform.workspace} monitoring node for Prometheus, Alert Manager и Grafana"

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
    ip_address = "${local.workspace["subnet_addr"]}.50"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
