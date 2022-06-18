resource "yandex_compute_instance" "ubuntu-node" {
  count                     = var.vm_count
  name                      = "ubu-node0${count.index + 1}"
  zone                      = var.yandex_zone
  hostname                  = "ubu-node0${count.index + 1}"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.image_ubuntu-20-04-lts-v20220606
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.ubu-subnet.id
    nat        = true
    ip_address = "${var.subnet_addr}.${count.index + 11}"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "internal_ip_address_ubuntu-node" {
  value = yandex_compute_instance.ubuntu-node[*].network_interface.0.ip_address
}

output "external_ip_address_ubuntu-node" {
  value = yandex_compute_instance.ubuntu-node[*].network_interface.0.nat_ip_address
}